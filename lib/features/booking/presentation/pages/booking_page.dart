import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../app/router/app_routes.dart';
import '../../../cafe/domain/models/cafe_detail.dart';
import '../../../cafe/presentation/providers/cafe_providers.dart';
import '../../domain/models/booking.dart';
import '../providers/booking_provider.dart';
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

  bool _isSubmitting = false;

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

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _confirmBooking(CafeDetail cafe) async {
    if (_isSubmitting) return;

    final selectedDate = _dates[_selectedDateIndex];
    final selectedTime = _times[_selectedTimeIndex];

    final parts = selectedTime.split(':');

    final bookingDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );

    if (!bookingDateTime.isAfter(DateTime.now())) {
      _showMessage('Please choose a future date and time.');
      return;
    }

    if (_guestCount < 1 || _guestCount > 10) {
      _showMessage('Guest count must be between 1 and 10.');
      return;
    }

    final notes = _notesController.text.trim();

    final request = Booking(
      cafeId: cafe.summary.id,
      cafeName: cafe.summary.name,
      date: selectedDate,
      time: selectedTime,
      guestCount: _guestCount,
      notes: notes.isEmpty ? null : notes,
    );

    setState(() {
      _isSubmitting = true;
    });

    try {
      final repository = ref.read(bookingRepositoryProvider);

      final savedBooking = await repository.createBooking(request);

      if (!mounted) return;

      context.pushReplacement(
        AppRoutes.bookingSuccessPath(savedBooking.cafeId),
        extra: savedBooking,
      );
    } on AuthException catch (error) {
      _showMessage(error.message);
    } on PostgrestException catch (_) {
      _showMessage('Could not save your booking. Please try again.');
    } catch (_) {
      _showMessage('Something went wrong. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cafeAsync = ref.watch(cafeDetailProvider(widget.cafeId));

    return cafeAsync.when(
      data: (cafe) {
        if (cafe == null) {
          return const BookingNotFoundPage();
        }

        return Stack(
          children: [
            BookingContent(
              cafe: cafe,
              dates: _dates,
              times: _times,
              selectedDateIndex: _selectedDateIndex,
              selectedTimeIndex: _selectedTimeIndex,
              guestCount: _guestCount,
              notesController: _notesController,
              onDateSelected: (index) {
                if (_isSubmitting) return;

                setState(() {
                  _selectedDateIndex = index;
                });
              },
              onTimeSelected: (index) {
                if (_isSubmitting) return;

                setState(() {
                  _selectedTimeIndex = index;
                });
              },
              onGuestDecrease: () {
                if (_isSubmitting || _guestCount <= 1) {
                  return;
                }

                setState(() {
                  _guestCount--;
                });
              },
              onGuestIncrease: () {
                if (_isSubmitting || _guestCount >= 10) {
                  return;
                }

                setState(() {
                  _guestCount++;
                });
              },
              onConfirm: () => _confirmBooking(cafe),
            ),
            if (_isSubmitting)
              Positioned.fill(
                child: ColoredBox(
                  color: Colors.black.withValues(alpha: 0.35),
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
              ),
          ],
        );
      },
      loading: () => const BookingLoadingPage(),
      error: (_, _) => BookingErrorPage(
        onRetry: () {
          ref.invalidate(cafeDetailProvider(widget.cafeId));
        },
      ),
    );
  }
}
