import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/cafe_detail.dart';
import '../../domain/models/cafe_summary.dart';
import '../../domain/repositories/cafe_repository.dart';

class SupabaseCafeRepository implements CafeRepository {
  const SupabaseCafeRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<List<CafeSummary>> getCafes() async {
    final cafeRows = await _client
        .from('cafes')
        .select()
        .eq('is_active', true)
        .order('name');

    if (cafeRows.isEmpty) {
      return [];
    }

    final ids = cafeRows.map((row) => row['id'] as String).toList();

    final results = await Future.wait([
      _client
          .from('cafe_crowd_status')
          .select('cafe_id, status')
          .inFilter('cafe_id', ids),
      _client
          .from('reviews')
          .select('cafe_id, rating')
          .inFilter('cafe_id', ids),
    ]);

    final statusRows = results[0];
    final reviewRows = results[1];

    final statusByCafe = <String, CafeLiveStatus>{};

    for (final row in statusRows) {
      final cafeId = row['cafe_id'] as String;

      statusByCafe[cafeId] = _parseLiveStatus(row['status'] as String?);
    }

    final ratingsByCafe = <String, List<int>>{};

    for (final row in reviewRows) {
      final cafeId = row['cafe_id'] as String;
      final rating = (row['rating'] as num).toInt();

      ratingsByCafe.putIfAbsent(cafeId, () => []).add(rating);
    }

    return cafeRows.map((row) {
      final id = row['id'] as String;
      final ratings = ratingsByCafe[id] ?? [];

      return _toSummary(
        row,
        liveStatus: statusByCafe[id] ?? CafeLiveStatus.moderate,
        rating: _averageRating(ratings),
      );
    }).toList();
  }

  @override
  Future<CafeDetail?> getCafeById(String id) async {
    final cafe = await _client
        .from('cafes')
        .select()
        .eq('id', id)
        .eq('is_active', true)
        .maybeSingle();

    if (cafe == null) {
      return null;
    }

    final results = await Future.wait([
      _client.from('cafe_crowd_status').select('status').eq('cafe_id', id),
      _client
          .from('cafe_facilities')
          .select('name')
          .eq('cafe_id', id)
          .order('name'),
      _client.from('reviews').select('rating').eq('cafe_id', id),
    ]);

    final statusRows = results[0];
    final facilityRows = results[1];
    final reviewRows = results[2];

    final status = statusRows.isEmpty
        ? CafeLiveStatus.moderate
        : _parseLiveStatus(statusRows.first['status'] as String?);

    final ratings = reviewRows
        .map((row) => (row['rating'] as num).toInt())
        .toList();

    final facilities = facilityRows
        .map((row) => _parseFacility(row['name'] as String?))
        .whereType<CafeFacility>()
        .toSet()
        .toList();

    return CafeDetail(
      summary: _toSummary(
        cafe,
        liveStatus: status,
        rating: _averageRating(ratings),
      ),
      description: (cafe['description'] as String?) ?? '',
      address: (cafe['address'] as String?) ?? '',
      openingHours: _formatOpeningHours(
        cafe['opening_time'] as String?,
        cafe['closing_time'] as String?,
      ),
      suitableFor: const [],
      facilities: facilities,
      menuItems: const [],
      reviewCount: ratings.length,
    );
  }

  CafeSummary _toSummary(
    Map<String, dynamic> row, {
    required CafeLiveStatus liveStatus,
    required double rating,
  }) {
    return CafeSummary(
      id: row['id'] as String,
      name: row['name'] as String,
      category: (row['category'] as String?) ?? 'Cafe',
      rating: rating,
      distance: 'Distance unavailable',
      liveStatus: liveStatus,
      imagePath: null,
    );
  }

  double _averageRating(List<int> ratings) {
    if (ratings.isEmpty) {
      return 0.0;
    }

    final total = ratings.fold<int>(0, (sum, rating) => sum + rating);

    return total / ratings.length;
  }

  CafeLiveStatus _parseLiveStatus(String? value) {
    switch (value?.toLowerCase()) {
      case 'quiet':
        return CafeLiveStatus.quiet;
      case 'crowded':
        return CafeLiveStatus.crowded;
      case 'moderate':
      default:
        return CafeLiveStatus.moderate;
    }
  }

  CafeFacility? _parseFacility(String? value) {
    final normalized = value?.trim().toLowerCase().replaceAll(
      RegExp(r'[\s_-]+'),
      '',
    );

    switch (normalized) {
      case 'wifi':
        return CafeFacility.wifi;
      case 'poweroutlet':
        return CafeFacility.powerOutlet;
      case 'parking':
        return CafeFacility.parking;
      case 'airconditioner':
      case 'ac':
        return CafeFacility.airConditioner;
      case 'outdoor':
      case 'outdoorseating':
        return CafeFacility.outdoor;
      case 'smokingarea':
        return CafeFacility.smokingArea;
      case 'prayerroom':
      case 'mushola':
        return CafeFacility.prayerRoom;
      case 'meetingroom':
        return CafeFacility.meetingRoom;
      case 'petfriendly':
        return CafeFacility.petFriendly;
      case 'toilet':
        return CafeFacility.toilet;
      case 'wheelchairaccessible':
        return CafeFacility.wheelchairAccessible;
      default:
        return null;
    }
  }

  String _formatOpeningHours(String? opening, String? closing) {
    if (opening == null || closing == null) {
      return 'Hours unavailable';
    }

    String shortTime(String value) {
      return value.length >= 5 ? value.substring(0, 5) : value;
    }

    return '${shortTime(opening)} - ${shortTime(closing)}';
  }
}
