import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/user_profile.dart';

class SupabaseProfileRepository {
  const SupabaseProfileRepository(this._client);

  final SupabaseClient _client;

  Future<UserProfile> getOrCreateProfile() async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw StateError('An authenticated user is required.');
    }

    final existing = await _getProfile(user.id);

    if (existing != null) {
      return existing;
    }

    final metadataName = user.userMetadata?['full_name'];

    final fullName = metadataName is String && metadataName.trim().isNotEmpty
        ? metadataName.trim()
        : null;

    try {
      final inserted = await _client
          .from('profiles')
          .insert({'id': user.id, 'full_name': fullName})
          .select('id, full_name, avatar_url')
          .single();

      return UserProfile.fromJson(inserted);
    } on PostgrestException catch (error) {
      // Another request may have created the same profile.
      // In that case, read the existing row instead.
      if (error.code == '23505') {
        final profile = await _getProfile(user.id);

        if (profile != null) {
          return profile;
        }
      }

      rethrow;
    }
  }

  Future<UserProfile?> _getProfile(String userId) async {
    final result = await _client
        .from('profiles')
        .select('id, full_name, avatar_url')
        .eq('id', userId)
        .maybeSingle();

    if (result == null) {
      return null;
    }

    return UserProfile.fromJson(result);
  }
}
