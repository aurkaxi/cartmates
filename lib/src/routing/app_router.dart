import 'package:cartmates/src/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:cartmates/src/features/auth/presentation/screens/login_screen.dart';
import 'package:cartmates/src/features/auth/presentation/screens/signup_screen.dart';
import 'package:cartmates/src/features/campaigns/presentation/screens/campaigns_page.dart';
import 'package:cartmates/src/features/cart/presentation/screens/cart_page.dart';
import 'package:cartmates/src/features/create/presentation/screens/create_page.dart';
import 'package:cartmates/src/features/deals/presentation/screens/same_product_deal_detail_page.dart';
import 'package:cartmates/src/features/deals/presentation/screens/deals_page.dart';
import 'package:cartmates/src/features/onboarding/presentation/screens/onboarding_page.dart';
import 'package:cartmates/src/features/profile/presentation/screens/profile_page.dart';
import 'package:cartmates/src/routing/app_routes.dart';
import 'package:cartmates/src/routing/app_scaffold.dart';
import 'package:cartmates/src/routing/global_navigator.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoutes.onboarding,
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
    ShellRoute(
      builder: (context, state, child) => AppScaffold(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.create,
          name: 'create',
          builder: (context, state) => const CreatePage(),
        ),
        GoRoute(
          path: AppRoutes.cart,
          name: 'cart',
          builder: (context, state) => const CartPage(),
        ),
        GoRoute(
          path: AppRoutes.deals,
          name: 'deals',
          builder: (context, state) => const DealsPage(),
        ),
        GoRoute(
          path: AppRoutes.campaigns,
          name: 'campaigns',
          builder: (context, state) => const CampaignsPage(),
        ),
        GoRoute(
          path: AppRoutes.profile,
          name: 'profile',
          builder: (context, state) => const ProfilePage(),
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.sameProductDealDetail,
      name: 'sameProductDealDetail',
      builder: (context, state) => SameProductDealDetailPage(
        dealId: state.pathParameters['id']!,
      ),
    ),
  ],
);
