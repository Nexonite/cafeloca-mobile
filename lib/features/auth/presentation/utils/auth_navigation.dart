import '../../../../app/router/app_routes.dart';

abstract final class AuthNavigation {
  static String loginPath({String? from}) {
    return _authPath(AppRoutes.login, from: from);
  }

  static String registerPath({String? from}) {
    return _authPath(AppRoutes.register, from: from);
  }

  static String destinationAfterAuth(String? from) {
    if (from == null || from.isEmpty) {
      return AppRoutes.home;
    }

    final uri = Uri.tryParse(from);

    if (uri == null ||
        uri.hasScheme ||
        uri.hasAuthority ||
        !from.startsWith('/') ||
        from.startsWith('//') ||
        from.contains('\\')) {
      return AppRoutes.home;
    }

    final path = uri.path;

    if (path == AppRoutes.login ||
        path == AppRoutes.register ||
        path == AppRoutes.splash ||
        path == AppRoutes.welcome) {
      return AppRoutes.home;
    }

    final bookingPattern = RegExp(r'^/cafe/[^/]+/booking$');
    final cafeDetailPattern = RegExp(r'^/cafe/[^/]+$');

    if (bookingPattern.hasMatch(path) || cafeDetailPattern.hasMatch(path)) {
      return uri.toString();
    }

    return AppRoutes.home;
  }

  static String? requestedDestination(Uri uri) {
    return uri.queryParameters['from'];
  }

  static String _authPath(String route, {String? from}) {
    if (from == null || from.isEmpty) {
      return route;
    }

    return Uri(path: route, queryParameters: {'from': from}).toString();
  }
}
