class AuthState {
  const AuthState.guest() : isAuthenticated = false, email = null, name = null;

  const AuthState.authenticated({required this.email, this.name})
    : isAuthenticated = true;

  final bool isAuthenticated;
  final String? email;
  final String? name;

  bool get isGuest => !isAuthenticated;
}
