import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/booking.dart';
import '../../domain/models/booking_history_item.dart';

class SupabaseBookingHistoryRepository {
  const SupabaseBookingHistoryRepository(this._client);

  final SupabaseClient _client;

  Future<List<BookingHistoryItem>> getMyBookings(String userId) async {
    final currentUser = _client.auth.currentUser;

    if (currentUser == null || currentUser.id != userId) {
      throw StateError('Please sign in to view your bookings.');
    }

    final rows = await _client
        .from('bookings')
        .select(
          'id, cafe_id, booking_date, booking_time, '
          'guest_count, status, notes, created_at',
        )
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    if (rows.isEmpty) {
      return [];
    }

    final cafeIds = rows
        .map((row) => row['cafe_id'] as String)
        .toSet()
        .toList();

    final cafeRows = await _client
        .from('cafes')
        .select('id, name')
        .inFilter('id', cafeIds);

    final cafeNames = {
      for (final cafe in cafeRows) cafe['id'] as String: cafe['name'] as String,
    };

    if (_client.auth.currentUser?.id != userId) {
      throw StateError('The authenticated user changed.');
    }

    return rows.map((row) {
      final cafeId = row['cafe_id'] as String;

      final rawTime = row['booking_time'] as String;

      final rawStatus = row['status'] as String;

      final status = BookingStatus.values.firstWhere(
        (value) => value.name == rawStatus,
        orElse: () => BookingStatus.pending,
      );

      return BookingHistoryItem(
        id: row['id'] as String,
        cafeId: cafeId,
        cafeName: cafeNames[cafeId] ?? 'Café unavailable',
        date: DateTime.parse(row['booking_date'] as String),
        time: rawTime.length >= 5 ? rawTime.substring(0, 5) : rawTime,
        guestCount: row['guest_count'] as int,
        status: status,
        notes: row['notes'] as String?,
        createdAt: DateTime.parse(row['created_at'] as String),
      );
    }).toList();
  }
}
