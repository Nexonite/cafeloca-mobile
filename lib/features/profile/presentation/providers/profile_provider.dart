import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/supabase_provider.dart';
import '../../data/repositories/supabase_profile_repository.dart';
import '../../domain/models/user_profile.dart';

final profileRepositoryProvider = Provider<SupabaseProfileRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);

  return SupabaseProfileRepository(client);
});

final userProfileProvider = FutureProvider.family<UserProfile, String>((
  ref,
  userId,
) async {
  final client = ref.watch(supabaseClientProvider);

  if (client.auth.currentUser?.id != userId) {
    throw StateError('The requested profile does not match the current user.');
  }

  final repository = ref.watch(profileRepositoryProvider);

  return repository.getOrCreateProfile();
});
