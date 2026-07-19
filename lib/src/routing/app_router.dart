import 'package:cartmates/src/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:cartmates/src/features/auth/presentation/screens/login_screen.dart';
import 'package:cartmates/src/features/auth/presentation/screens/signup_screen.dart';
import 'package:cartmates/src/features/onboarding/presentation/screens/onboarding_page.dart';
import 'package:cartmates/src/features/deals/presentation/screens/deals_page.dart';
import 'package:cartmates/src/features/cart/presentation/screens/cart_page.dart';
import 'package:cartmates/src/features/create/presentation/screens/create_page.dart';
import 'package:cartmates/src/features/campaigns/presentation/screens/campaigns_page.dart';
import 'package:cartmates/src/features/profile/presentation/screens/profile_page.dart';
import 'package:cartmates/src/routing/app_routes.dart';
import 'package:cartmates/src/routing/global_navigator.dart';
import 'package:cartmates/src/shared/widgets/scaffold_with_nav_bar.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoutes.signup,
  routes: <RouteBase>[
    GoRoute(
      path: AppRoutes.onboarding,
      name: 'onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.signup,
      name: 'signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      name: 'forgotPassword',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: AppRoutes.deals,
      name: 'home',
      builder: (context, state) => const DealsPage(),
    ),
  ],
);
