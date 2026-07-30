import 'package:cartmates/src/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:cartmates/src/features/auth/presentation/screens/login_screen.dart';
import 'package:cartmates/src/features/auth/presentation/screens/signup_screen.dart';
import 'package:cartmates/src/features/saved/presentation/screens/saved_page.dart';
import 'package:cartmates/src/features/cart/presentation/screens/cart_page.dart';
import 'package:cartmates/src/features/cart/presentation/screens/manage_order_page.dart';
import 'package:cartmates/src/features/cart/presentation/screens/order_status_page.dart';
import 'package:cartmates/src/features/create/presentation/screens/create_same_product_deal_page.dart';
import 'package:cartmates/src/features/deals/presentation/screens/join_same_product_deal_page.dart';
import 'package:cartmates/src/features/deals/presentation/screens/same_product_deal_detail_page.dart';
import 'package:cartmates/src/features/deals/presentation/screens/deals_page.dart';
import 'package:cartmates/src/features/onboarding/presentation/screens/onboarding_page.dart';
import 'package:cartmates/src/features/profile/presentation/screens/profile_page.dart';
import 'package:cartmates/src/features/profile/presentation/screens/public_profile_page.dart';
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
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => AppScaffold(
        navigationShell: navigationShell,
      ),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.create,
              name: 'create',
              builder: (context, state) => const CreateSameProductDealPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.cart,
              name: 'cart',
              builder: (context, state) => const CartPage(),
              routes: [
                GoRoute(
                  path: 'order/:dealId',
                  name: 'cartOrder',
                  builder: (context, state) => OrderStatusPage(
                    dealId: state.pathParameters['dealId']!,
                  ),
                ),
                GoRoute(
                  path: 'manage/:dealId',
                  name: 'manageOrder',
                  builder: (context, state) => ManageOrderPage(
                    dealId: state.pathParameters['dealId']!,
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.deals,
              name: 'deals',
              builder: (context, state) => const DealsPage(),
              routes: [
                GoRoute(
                  path: 'detail/:id',
                  name: 'sameProductDealDetail',
                  builder: (context, state) => SameProductDealDetailPage(
                    dealId: state.pathParameters['id']!,
                  ),
                  routes: [
                    GoRoute(
                      path: 'join',
                      name: 'joinSameProductDeal',
                      builder: (context, state) => JoinSameProductDealPage(
                        dealId: state.pathParameters['id']!,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.saved,
              name: 'saved',
              builder: (context, state) => const SavedPage(),
              routes: [
                GoRoute(
                  path: 'detail/:id',
                  name: 'savedDealDetail',
                  builder: (context, state) => SameProductDealDetailPage(
                    dealId: state.pathParameters['id']!,
                  ),
                  routes: [
                    GoRoute(
                      path: 'join',
                      name: 'joinSavedDeal',
                      builder: (context, state) => JoinSameProductDealPage(
                        dealId: state.pathParameters['id']!,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.profile,
              name: 'profile',
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.publicProfile,
      name: 'publicProfile',
      builder: (context, state) => PublicProfilePage(
        userId: state.pathParameters['userId']!,
      ),
    ),
  ],
);
