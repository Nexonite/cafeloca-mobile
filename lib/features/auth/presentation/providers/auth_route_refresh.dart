import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRouteRefresh extends ChangeNotifier {
  AuthRouteRefresh._();

  static final AuthRouteRefresh instance = AuthRouteRefresh._();

  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  void initialize() {
    final session = Supabase.instance.client.auth.currentSession;

    update(session != null);
  }

  void update(bool isAuthenticated) {
    if (_isAuthenticated == isAuthenticated) {
      return;
    }

    _isAuthenticated = isAuthenticated;
    notifyListeners();
  }
}
