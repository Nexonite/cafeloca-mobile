import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/dummy_cafe_repository.dart';
import '../../domain/models/cafe_detail.dart';
import '../../domain/models/cafe_summary.dart';
import '../../domain/repositories/cafe_repository.dart';

final cafeRepositoryProvider = Provider<CafeRepository>((ref) {
  return const DummyCafeRepository();
});

final cafesProvider = FutureProvider<List<CafeSummary>>((ref) async {
  final repository = ref.watch(cafeRepositoryProvider);

  return repository.getCafes();
});

final cafeDetailProvider = FutureProvider.family<CafeDetail?, String>((
  ref,
  cafeId,
) async {
  final repository = ref.watch(cafeRepositoryProvider);

  return repository.getCafeById(cafeId);
});
