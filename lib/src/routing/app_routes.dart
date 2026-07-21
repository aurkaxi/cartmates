/// Centralized route path constants for GoRouter.
///
/// Use these variables instead of raw strings throughout the app.
/// Example: `context.go(AppRoutes.onboarding)` instead of `context.go('/')`.
abstract final class AppRoutes {
  AppRoutes._();

  static const String splash = '/splash';
  static const String create = '/create';
  static const String campaigns = '/campaigns';
  static const String deals = '/deals';
  static const String cart = '/cart';
  static const String profile = '/profile';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String _sameProductDealBase = '/same-product-deal';
  static const String sameProductDealDetail = '$_sameProductDealBase/:id';

  static String sameProductDealDetailPath(String id) =>
      '$_sameProductDealBase/$id';
}
