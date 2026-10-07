import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
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
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterPage(),
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
