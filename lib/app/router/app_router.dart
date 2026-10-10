import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/providers/auth_route_refresh.dart';
import '../../features/auth/presentation/utils/auth_navigation.dart';
import '../../features/booking/domain/models/booking.dart';
import '../../features/booking/presentation/pages/booking_page.dart';
import '../../features/booking/presentation/pages/booking_success_page.dart';
import '../../features/cafe/presentation/pages/cafe_detail_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/welcome/presentation/pages/welcome_page.dart';
import '../shell/main_shell.dart';
import 'app_routes.dart';

abstract final class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: AuthRouteRefresh.instance,
    redirect: (context, state) {
      final isAuthenticated = AuthRouteRefresh.instance.isAuthenticated;

      final path = state.uri.path;

      final bookingPattern = RegExp(r'^/cafe/[^/]+/booking$');

      final bookingSuccessPattern = RegExp(r'^/cafe/[^/]+/booking/success$');

      final isBookingRoute = bookingPattern.hasMatch(path);

      final isProtected =
          isBookingRoute || bookingSuccessPattern.hasMatch(path);

      if (!isAuthenticated && isProtected) {
        return AuthNavigation.loginPath(
          from: isBookingRoute ? state.uri.toString() : null,
        );
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.welcome,
        builder: (context, state) => const WelcomePage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) =>
            LoginPage(from: state.uri.queryParameters['from']),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) =>
            RegisterPage(from: state.uri.queryParameters['from']),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const MainShell(),
      ),
      GoRoute(
        path: AppRoutes.cafeDetail,
        builder: (context, state) {
          final cafeId = state.pathParameters['id'] ?? '';

          return CafeDetailPage(cafeId: cafeId);
        },
      ),
      GoRoute(
        path: AppRoutes.booking,
        builder: (context, state) {
          final cafeId = state.pathParameters['id'] ?? '';

          return BookingPage(cafeId: cafeId);
        },
      ),
      GoRoute(
        path: AppRoutes.bookingSuccess,
        builder: (context, state) {
          final cafeId = state.pathParameters['id'] ?? '';

          final extra = state.extra;

          if (extra is! Booking) {
            return BookingPage(cafeId: cafeId);
          }

          return BookingSuccessPage(booking: extra);
        },
      ),
    ],
  );
}
