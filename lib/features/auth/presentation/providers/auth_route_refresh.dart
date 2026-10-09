import 'package:flutter/foundation.dart';

class AuthRouteRefresh extends ChangeNotifier {
  AuthRouteRefresh._();

  static final AuthRouteRefresh instance = AuthRouteRefresh._();

  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  void update(bool isAuthenticated) {
    if (_isAuthenticated == isAuthenticated) {
      return;
    }

    _isAuthenticated = isAuthenticated;
    notifyListeners();
  }
}
