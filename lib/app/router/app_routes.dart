abstract final class AppRoutes {
  static const String splash = '/splash';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';

  static const String myBookings = '/my-bookings';

  static const String cafeDetail = '/cafe/:id';
  static const String booking = '/cafe/:id/booking';
  static const String bookingSuccess = '/cafe/:id/booking/success';

  static String cafeDetailPath(String id) {
    return '/cafe/$id';
  }

  static String bookingPath(String id) {
    return '/cafe/$id/booking';
  }

  static String bookingSuccessPath(String id) {
    return '/cafe/$id/booking/success';
  }
}
