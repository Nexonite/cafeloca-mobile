import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/supabase_provider.dart';
import '../../data/repositories/supabase_booking_history_repository.dart';
import '../../domain/models/booking_history_item.dart';

final bookingHistoryRepositoryProvider =
    Provider<SupabaseBookingHistoryRepository>((ref) {
      final client = ref.watch(supabaseClientProvider);

      return SupabaseBookingHistoryRepository(client);
    });

final myBookingsProvider =
    FutureProvider.family<List<BookingHistoryItem>, String>((
      ref,
      userId,
    ) async {
      final repository = ref.watch(bookingHistoryRepositoryProvider);

      return repository.getMyBookings(userId);
    });
