import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/supabase_config.dart';
import '../../../../core/providers/supabase_provider.dart';
import '../../data/repositories/dummy_cafe_repository.dart';
import '../../data/repositories/supabase_cafe_repository.dart';
import '../../domain/models/cafe_detail.dart';
import '../../domain/models/cafe_summary.dart';
import '../../domain/repositories/cafe_repository.dart';

const bool useDummyCafes = bool.fromEnvironment(
  'USE_DUMMY_CAFES',
  defaultValue: false,
);

final cafeRepositoryProvider = Provider<CafeRepository>((ref) {
  if (useDummyCafes) {
    return const DummyCafeRepository();
  }

  if (!SupabaseConfig.isConfigured) {
    throw StateError(
      'Supabase configuration is missing. '
      'Run with --dart-define-from-file=env/dev.json '
      'or --dart-define=USE_DUMMY_CAFES=true.',
    );
  }

  final client = ref.watch(supabaseClientProvider);

  return SupabaseCafeRepository(client);
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
