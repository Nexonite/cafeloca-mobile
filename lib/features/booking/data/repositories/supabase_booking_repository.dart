import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/booking.dart';

class SupabaseBookingRepository {
  const SupabaseBookingRepository(this._client);

  final SupabaseClient _client;

  Future<Booking> createBooking(Booking booking) async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw StateError('Please sign in before making a booking.');
    }

    final date = booking.date;

    final dateString =
        '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';

    final result = await _client
        .from('bookings')
        .insert({
          'user_id': user.id,
          'cafe_id': booking.cafeId,
          'booking_date': dateString,
          'booking_time': booking.time,
          'guest_count': booking.guestCount,
          'notes': booking.notes,
          'status': 'pending',
        })
        .select(
          'id, cafe_id, booking_date, booking_time, '
          'guest_count, notes, status',
        )
        .single();

    final returnedDate = DateTime.parse(result['booking_date'] as String);

    final returnedTime = result['booking_time'] as String;

    final statusValue = result['status'] as String;

    final status = BookingStatus.values.firstWhere(
      (value) => value.name == statusValue,
      orElse: () => BookingStatus.pending,
    );

    return Booking(
      id: result['id'] as String,
      cafeId: result['cafe_id'] as String,
      cafeName: booking.cafeName,
      date: returnedDate,
      time: returnedTime.length >= 5
          ? returnedTime.substring(0, 5)
          : returnedTime,
      guestCount: result['guest_count'] as int,
      notes: result['notes'] as String?,
      status: status,
    );
  }
}
