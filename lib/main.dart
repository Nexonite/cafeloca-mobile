import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/app.dart';
import 'core/config/supabase_config.dart';
import 'features/auth/presentation/providers/auth_route_refresh.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!SupabaseConfig.isConfigured) {
    throw StateError(
      'Supabase is not configured. '
      'Run the app with --dart-define-from-file=env/dev.json',
    );
  }

  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.publishableKey,
  );

  AuthRouteRefresh.instance.initialize();

  runApp(const ProviderScope(child: CafelocaApp()));
}
