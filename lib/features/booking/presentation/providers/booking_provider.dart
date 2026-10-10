import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/supabase_provider.dart';
import '../../data/repositories/supabase_booking_repository.dart';
import '../../domain/models/booking.dart';

final bookingRepositoryProvider = Provider<SupabaseBookingRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);

  return SupabaseBookingRepository(client);
});

final createBookingProvider = FutureProvider.family<Booking, Booking>((
  ref,
  booking,
) async {
  final repository = ref.watch(bookingRepositoryProvider);

  return repository.createBooking(booking);
});
