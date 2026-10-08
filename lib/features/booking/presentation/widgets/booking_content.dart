import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../cafe/domain/models/cafe_detail.dart';

import 'booking_bottom_action.dart';
import 'booking_cafe_summary.dart';
import 'booking_date_selector.dart';
import 'booking_guest_selector.dart';
import 'booking_notes_field.dart';
import 'booking_section_title.dart';
import 'booking_summary.dart';
import 'booking_time_selector.dart';

class BookingContent extends StatelessWidget {
  const BookingContent({
    super.key,
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
                    BookingCafeSummary(cafe: cafe),

                    const SizedBox(height: 32),

                    const BookingSectionTitle(
                      title: 'Choose a date',
                      subtitle: 'Select when you want to visit.',
                    ),

                    const SizedBox(height: 16),

                    BookingDateSelector(
                      dates: dates,
                      selectedIndex: selectedDateIndex,
                      onSelected: onDateSelected,
                    ),

                    const SizedBox(height: 34),

                    const BookingSectionTitle(
                      title: 'Choose a time',
                      subtitle: 'Available time slots for your visit.',
                    ),

                    const SizedBox(height: 16),

                    BookingTimeSelector(
                      times: times,
                      selectedIndex: selectedTimeIndex,
                      onSelected: onTimeSelected,
                    ),

                    const SizedBox(height: 34),

                    const BookingSectionTitle(
                      title: 'Guests',
                      subtitle: 'How many people are coming?',
                    ),

                    const SizedBox(height: 16),

                    BookingGuestSelector(
                      guestCount: guestCount,
                      onDecrease: onGuestDecrease,
                      onIncrease: onGuestIncrease,
                    ),

                    const SizedBox(height: 34),

                    const BookingSectionTitle(
                      title: 'Notes',
                      subtitle: 'Anything the café should know?',
                    ),

                    const SizedBox(height: 14),

                    BookingNotesField(controller: notesController),

                    const SizedBox(height: 34),

                    BookingSummary(
                      date: dates[selectedDateIndex],
                      time: times[selectedTimeIndex],
                      guestCount: guestCount,
                    ),
                  ],
                ),
              ),
            ),

            BookingBottomAction(onPressed: onConfirm),
          ],
        ),
      ),
    );
  }
}
