import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/supabase_config.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  if (!SupabaseConfig.isConfigured) {
    throw StateError(
      'Supabase is not configured. '
      'Run the app with --dart-define-from-file=env/dev.json',
    );
  }

  return Supabase.instance.client;
});
