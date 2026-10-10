import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../../../core/providers/supabase_provider.dart';
import '../../../saved/presentation/providers/saved_cafes_provider.dart';
import 'auth_route_refresh.dart';
import 'auth_state.dart';

class AuthNotifier extends Notifier<AuthState> {
  StreamSubscription<supabase.AuthState>? _subscription;

  late supabase.SupabaseClient _client;

  @override
  AuthState build() {
    _client = ref.watch(supabaseClientProvider);

    _subscription?.cancel();

    _subscription = _client.auth.onAuthStateChange.listen((event) {
      _updateFromSession(event.session);
    });

    ref.onDispose(() {
      _subscription?.cancel();
    });

    final session = _client.auth.currentSession;

    final initialState = _stateFromSession(session);

    Future.microtask(() {
      AuthRouteRefresh.instance.update(_client.auth.currentSession != null);
    });

    return initialState;
  }

  AuthState _stateFromSession(supabase.Session? session) {
    final user = session?.user;

    if (user == null) {
      return const AuthState.guest();
    }

    final metadataName = user.userMetadata?['full_name'];

    return AuthState.authenticated(
      email: user.email,
      name: metadataName is String && metadataName.trim().isNotEmpty
          ? metadataName.trim()
          : null,
    );
  }

  void _updateFromSession(supabase.Session? session) {
    final nextState = _stateFromSession(session);

    final wasAuthenticated = state.isAuthenticated;
    final isAuthenticated = nextState.isAuthenticated;

    if (wasAuthenticated != isAuthenticated) {
      ref.read(savedCafesProvider.notifier).clear();
    }

    state = nextState;

    AuthRouteRefresh.instance.update(isAuthenticated);
  }

  Future<void> signIn({required String email, required String password}) async {
    final response = await _client.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );

    if (response.session == null) {
      throw const supabase.AuthException(
        'Sign in failed. No active session was returned.',
      );
    }

    _updateFromSession(response.session);
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signUp(
      email: email.trim(),
      password: password,
      data: {'full_name': name.trim()},
    );

    if (response.session != null) {
      _updateFromSession(response.session);
      return true;
    }

    return false;
  }

  Future<void> signOut() async {
    await _client.auth.signOut();

    ref.read(savedCafesProvider.notifier).clear();

    _updateFromSession(null);
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
