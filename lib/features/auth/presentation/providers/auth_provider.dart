import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../saved/presentation/providers/saved_cafes_provider.dart';
import 'auth_route_refresh.dart';
import 'auth_state.dart';

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    return const AuthState.guest();
  }

  void signIn({required String email}) {
    ref.read(savedCafesProvider.notifier).clear();

    state = AuthState.authenticated(email: email.trim());

    AuthRouteRefresh.instance.update(true);
  }

  void register({required String name, required String email}) {
    ref.read(savedCafesProvider.notifier).clear();

    state = AuthState.authenticated(name: name.trim(), email: email.trim());

    AuthRouteRefresh.instance.update(true);
  }

  void signOut() {
    ref.read(savedCafesProvider.notifier).clear();

    state = const AuthState.guest();

    AuthRouteRefresh.instance.update(false);
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
