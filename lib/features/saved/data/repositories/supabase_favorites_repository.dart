import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseFavoritesRepository {
  const SupabaseFavoritesRepository(this._client);

  final SupabaseClient _client;

  Future<Set<String>> getFavoriteCafeIds(String userId) async {
    final rows = await _client
        .from('favorites')
        .select('cafe_id')
        .eq('user_id', userId);

    return rows.map((row) => row['cafe_id'] as String).toSet();
  }

  Future<void> addFavorite({
    required String userId,
    required String cafeId,
  }) async {
    await _client
        .from('favorites')
        .upsert(
          {'user_id': userId, 'cafe_id': cafeId},
          onConflict: 'user_id,cafe_id',
          ignoreDuplicates: true,
        );
  }

  Future<void> removeFavorite({
    required String userId,
    required String cafeId,
  }) async {
    await _client
        .from('favorites')
        .delete()
        .eq('user_id', userId)
        .eq('cafe_id', cafeId);
  }
}
