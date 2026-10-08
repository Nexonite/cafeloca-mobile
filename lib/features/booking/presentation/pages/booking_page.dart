import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../cafe/domain/models/cafe_detail.dart';
import '../../../cafe/presentation/providers/cafe_providers.dart';
import '../../domain/models/booking.dart';
import '../widgets/booking_content.dart';
import '../widgets/booking_states.dart';

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
          return const BookingNotFoundPage();
        }

        return BookingContent(
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
            if (_guestCount <= 1) return;

            setState(() {
              _guestCount--;
            });
          },
          onGuestIncrease: () {
            if (_guestCount >= 10) return;

            setState(() {
              _guestCount++;
            });
          },
          onConfirm: () => _confirmBooking(cafe),
        );
      },
      loading: () => const BookingLoadingPage(),
      error: (error, stackTrace) {
        return BookingErrorPage(
          onRetry: () {
            ref.invalidate(cafeDetailProvider(widget.cafeId));
          },
        );
      },
    );
  }
}
