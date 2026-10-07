import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../cafe/domain/models/cafe_detail.dart';
import '../../../cafe/presentation/providers/cafe_providers.dart';
import '../../domain/models/booking.dart';

class BookingPage extends ConsumerStatefulWidget {
  const BookingPage({super.key, required this.cafeId});

  final String cafeId;

  @override
  ConsumerState<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends ConsumerState<BookingPage> {
  final TextEditingController _notesController = TextEditingController();

  late final List<DateTime> _dates;

  int _selectedDateIndex = 0;
  int _selectedTimeIndex = 2;
  int _guestCount = 2;

  static const List<String> _times = [
    '10:00',
    '11:00',
    '12:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00',
    '17:00',
    '18:00',
    '19:00',
    '20:00',
  ];

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();

    _dates = List.generate(
      7,
      (index) => DateTime(now.year, now.month, now.day + index),
    );
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _confirmBooking(CafeDetail cafe) {
    final notes = _notesController.text.trim();

    final booking = Booking(
      cafeId: cafe.summary.id,
      cafeName: cafe.summary.name,
      date: _dates[_selectedDateIndex],
      time: _times[_selectedTimeIndex],
      guestCount: _guestCount,
      notes: notes.isEmpty ? null : notes,
    );

    context.pushReplacement(
      AppRoutes.bookingSuccessPath(booking.cafeId),
      extra: booking,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cafeAsync = ref.watch(cafeDetailProvider(widget.cafeId));

    return cafeAsync.when(
      data: (cafe) {
        if (cafe == null) {
          return const _BookingNotFoundPage();
        }

        return _BookingContent(
          cafe: cafe,
          dates: _dates,
          times: _times,
          selectedDateIndex: _selectedDateIndex,
          selectedTimeIndex: _selectedTimeIndex,
          guestCount: _guestCount,
          notesController: _notesController,
          onDateSelected: (index) {
            setState(() {
              _selectedDateIndex = index;
            });
          },
          onTimeSelected: (index) {
            setState(() {
              _selectedTimeIndex = index;
            });
          },
          onGuestDecrease: () {
            if (_guestCount <= 1) {
              return;
            }

            setState(() {
              _guestCount--;
            });
          },
          onGuestIncrease: () {
            if (_guestCount >= 10) {
              return;
            }

            setState(() {
              _guestCount++;
            });
          },
          onConfirm: () {
            _confirmBooking(cafe);
          },
        );
      },
      loading: () {
        return const _BookingLoadingPage();
      },
      error: (error, stackTrace) {
        return _BookingErrorPage(
          onRetry: () {
            ref.invalidate(cafeDetailProvider(widget.cafeId));
          },
        );
      },
    );
  }
}

class _BookingContent extends StatelessWidget {
  const _BookingContent({
    required this.cafe,
    required this.dates,
    required this.times,
    required this.selectedDateIndex,
    required this.selectedTimeIndex,
    required this.guestCount,
    required this.notesController,
    required this.onDateSelected,
    required this.onTimeSelected,
    required this.onGuestDecrease,
    required this.onGuestIncrease,
    required this.onConfirm,
  });

  final CafeDetail cafe;
  final List<DateTime> dates;
  final List<String> times;
  final int selectedDateIndex;
  final int selectedTimeIndex;
  final int guestCount;
  final TextEditingController notesController;
  final ValueChanged<int> onDateSelected;
  final ValueChanged<int> onTimeSelected;
  final VoidCallback onGuestDecrease;
  final VoidCallback onGuestIncrease;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.cafeDetailPath(cafe.summary.id));
            }
          },
          icon: const Icon(Icons.arrow_back_rounded),
          color: AppColors.textPrimary,
        ),
        title: Text(
          'Book a table',
          style: AppTypography.title.copyWith(color: AppColors.textPrimary),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CafeSummary(cafe: cafe),

                    const SizedBox(height: 32),

                    const _SectionTitle(
                      title: 'Choose a date',
                      subtitle: 'Select when you want to visit.',
                    ),

                    const SizedBox(height: 16),

                    _DateSelector(
                      dates: dates,
                      selectedIndex: selectedDateIndex,
                      onSelected: onDateSelected,
                    ),

                    const SizedBox(height: 34),

                    const _SectionTitle(
                      title: 'Choose a time',
                      subtitle: 'Available time slots for your visit.',
                    ),

                    const SizedBox(height: 16),

                    _TimeSelector(
                      times: times,
                      selectedIndex: selectedTimeIndex,
                      onSelected: onTimeSelected,
                    ),

                    const SizedBox(height: 34),

                    const _SectionTitle(
                      title: 'Guests',
                      subtitle: 'How many people are coming?',
                    ),

                    const SizedBox(height: 16),

                    _GuestSelector(
                      guestCount: guestCount,
                      onDecrease: onGuestDecrease,
                      onIncrease: onGuestIncrease,
                    ),

                    const SizedBox(height: 34),

                    const _SectionTitle(
                      title: 'Notes',
                      subtitle: 'Anything the café should know?',
                    ),

                    const SizedBox(height: 14),

                    _NotesField(controller: notesController),

                    const SizedBox(height: 34),

                    _BookingSummary(
                      date: dates[selectedDateIndex],
                      time: times[selectedTimeIndex],
                      guestCount: guestCount,
                    ),
                  ],
                ),
              ),
            ),

            _BottomAction(onPressed: onConfirm),
          ],
        ),
      ),
    );
  }
}

class _CafeSummary extends StatelessWidget {
  const _CafeSummary({required this.cafe});

  final CafeDetail cafe;

  @override
  Widget build(BuildContext context) {
    final imagePath = cafe.summary.imagePath;

    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: 72,
            height: 72,
            child: imagePath != null
                ? Image.asset(imagePath, fit: BoxFit.cover)
                : Container(
                    color: AppColors.surfaceSoft,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.local_cafe_outlined,
                      color: AppColors.textTertiary,
                    ),
                  ),
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cafe.summary.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.title.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                cafe.address,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 5),

              Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    size: 16,
                    color: AppColors.rating,
                  ),

                  const SizedBox(width: 4),

                  Text(
                    cafe.summary.rating.toStringAsFixed(1),
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  Text(
                    '  •  ${cafe.summary.distance}',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.heading2.copyWith(color: AppColors.textPrimary),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _DateSelector extends StatelessWidget {
  const _DateSelector({
    required this.dates,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<DateTime> dates;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const List<String> _weekdays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  static const List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 86,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        separatorBuilder: (context, index) {
          return const SizedBox(width: 9);
        },
        itemBuilder: (context, index) {
          final date = dates[index];
          final selected = index == selectedIndex;

          return InkWell(
            onTap: () {
              onSelected(index);
            },
            borderRadius: BorderRadius.circular(12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 64,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: selected ? AppColors.textPrimary : AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected ? AppColors.textPrimary : AppColors.border,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _weekdays[date.weekday - 1],
                    style: AppTypography.tiny.copyWith(
                      color: selected
                          ? AppColors.surface
                          : AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    '${date.day}',
                    style: AppTypography.title.copyWith(
                      color: selected
                          ? AppColors.surface
                          : AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    _months[date.month - 1],
                    style: AppTypography.tiny.copyWith(
                      color: selected
                          ? AppColors.surface
                          : AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TimeSelector extends StatelessWidget {
  const _TimeSelector({
    required this.times,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> times;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 9,
      runSpacing: 9,
      children: List.generate(times.length, (index) {
        final selected = index == selectedIndex;

        return InkWell(
          onTap: () {
            onSelected(index);
          },
          borderRadius: BorderRadius.circular(10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 76,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? AppColors.textPrimary : AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: selected ? AppColors.textPrimary : AppColors.border,
              ),
            ),
            child: Text(
              times[index],
              style: AppTypography.label.copyWith(
                color: selected ? AppColors.surface : AppColors.textPrimary,
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _GuestSelector extends StatelessWidget {
  const _GuestSelector({
    required this.guestCount,
    required this.onDecrease,
    required this.onIncrease,
  });

  final int guestCount;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.people_outline_rounded,
            size: 21,
            color: AppColors.textSecondary,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              '$guestCount ${guestCount == 1 ? 'guest' : 'guests'}',
              style: AppTypography.body.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          _CounterButton(
            icon: Icons.remove_rounded,
            enabled: guestCount > 1,
            onTap: onDecrease,
          ),

          SizedBox(
            width: 42,
            child: Text(
              '$guestCount',
              textAlign: TextAlign.center,
              style: AppTypography.title.copyWith(color: AppColors.textPrimary),
            ),
          ),

          _CounterButton(
            icon: Icons.add_rounded,
            enabled: guestCount < 10,
            onTap: onIncrease,
          ),
        ],
      ),
    );
  }
}

class _CounterButton extends StatelessWidget {
  const _CounterButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(9),
      child: Container(
        width: 34,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.surfaceSoft,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(
          icon,
          size: 17,
          color: enabled ? AppColors.textPrimary : AppColors.textTertiary,
        ),
      ),
    );
  }
}

class _NotesField extends StatelessWidget {
  const _NotesField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      minLines: 3,
      maxLines: 5,
      maxLength: 200,
      style: AppTypography.body.copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: 'Example: table near the window',
        hintStyle: AppTypography.body.copyWith(color: AppColors.textTertiary),
        counterStyle: AppTypography.tiny.copyWith(
          color: AppColors.textTertiary,
        ),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.all(14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.espresso),
        ),
      ),
    );
  }
}

class _BookingSummary extends StatelessWidget {
  const _BookingSummary({
    required this.date,
    required this.time,
    required this.guestCount,
  });

  final DateTime date;
  final String time;
  final int guestCount;

  static const List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Booking summary',
            style: AppTypography.title.copyWith(color: AppColors.textPrimary),
          ),

          const SizedBox(height: 16),

          _SummaryRow(
            icon: Icons.calendar_today_outlined,
            label: '${date.day} ${_months[date.month - 1]} ${date.year}',
          ),

          const SizedBox(height: 12),

          _SummaryRow(icon: Icons.schedule_outlined, label: time),

          const SizedBox(height: 12),

          _SummaryRow(
            icon: Icons.people_outline_rounded,
            label: '$guestCount ${guestCount == 1 ? 'guest' : 'guests'}',
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 11),
        Text(
          label,
          style: AppTypography.body.copyWith(color: AppColors.textPrimary),
        ),
      ],
    );
  }
}

class _BottomAction extends StatelessWidget {
  const _BottomAction({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: FilledButton(
            onPressed: onPressed,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.textPrimary,
              foregroundColor: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Confirm booking',
              style: AppTypography.label.copyWith(
                color: AppColors.surface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BookingLoadingPage extends StatelessWidget {
  const _BookingLoadingPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.home);
            }
          },
          icon: const Icon(Icons.arrow_back_rounded),
          color: AppColors.textPrimary,
        ),
        title: Text(
          'Book a table',
          style: AppTypography.title.copyWith(color: AppColors.textPrimary),
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.espresso,
          ),
        ),
      ),
    );
  }
}

class _BookingErrorPage extends StatelessWidget {
  const _BookingErrorPage({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.home);
            }
          },
          icon: const Icon(Icons.arrow_back_rounded),
          color: AppColors.textPrimary,
        ),
        title: Text(
          'Book a table',
          style: AppTypography.title.copyWith(color: AppColors.textPrimary),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 58,
                height: 58,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.border),
                ),
                child: const Icon(
                  Icons.wifi_off_rounded,
                  size: 25,
                  color: AppColors.textTertiary,
                ),
              ),

              const SizedBox(height: 18),

              Text(
                'Couldn\'t load café',
                style: AppTypography.title.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                'Something went wrong while preparing your booking.',
                textAlign: TextAlign.center,
                style: AppTypography.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 18),

              OutlinedButton(
                onPressed: onRetry,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookingNotFoundPage extends StatelessWidget {
  const _BookingNotFoundPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.home);
            }
          },
          icon: const Icon(Icons.arrow_back_rounded),
          color: AppColors.textPrimary,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            'Café not found.',
            textAlign: TextAlign.center,
            style: AppTypography.body.copyWith(color: AppColors.textSecondary),
          ),
        ),
      ),
    );
  }
}
