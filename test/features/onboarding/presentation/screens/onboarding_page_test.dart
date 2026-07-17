import 'package:cartmates/src/features/onboarding/presentation/screens/onboarding_page.dart';
import 'package:cartmates/src/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  group('OnboardingPage', () {
    late GoRouter router;

    setUpAll(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      // Set a larger test window size to accommodate the full onboarding page
      // Using 1080x2340 physical pixels at 2.0 ratio = 540x1170 logical
      final binding = TestWidgetsFlutterBinding.instance;
      binding.window.physicalSizeTestValue = const Size(1080, 2340);
      binding.window.devicePixelRatioTestValue = 2.0;
    });

    tearDownAll(() {
      final binding = TestWidgetsFlutterBinding.instance;
      binding.window.clearPhysicalSizeTestValue();
      binding.window.clearDevicePixelRatioTestValue();
    });

    setUp(() {
      router = GoRouter(
        initialLocation: AppRoutes.onboarding,
        routes: [
          GoRoute(
            path: AppRoutes.onboarding,
            builder: (context, state) => const OnboardingPage(),
          ),
          GoRoute(
            path: AppRoutes.signup,
            builder: (context, state) => const _TestPage('Signup'),
          ),
          GoRoute(
            path: AppRoutes.login,
            builder: (context, state) => const _TestPage('Login'),
          ),
          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const _TestPage('Home'),
          ),
        ],
      );
    });

    Widget createTestWidget() {
      return ProviderScope(
        child: ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp.router(
              routerConfig: router,
            );
          },
        ),
      );
    }

    testWidgets('renders onboarding screen with all elements',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('cartmates'), findsOneWidget);
      expect(find.text('Buy together, save together.'), findsOneWidget);
      expect(find.text('Save on Product Cost'), findsOneWidget);
      expect(find.text('Team up to unlock bulk tier discounts.'), findsOneWidget);
      expect(find.text('Save on Delivery'), findsOneWidget);
      expect(find.text('Split shipping fees with your campus community.'),
          findsOneWidget);
      expect(find.text('Register'), findsOneWidget);
      expect(find.text('Log In'), findsOneWidget);
      expect(find.text('Continue as Guest'), findsOneWidget);
    });

    testWidgets('navigates to signup when Register is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      expect(router.routerDelegate.currentConfiguration.uri.toString(),
          AppRoutes.signup);
    });

    testWidgets('navigates to login when Log In is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Log In'));
      await tester.pumpAndSettle();

      expect(router.routerDelegate.currentConfiguration.uri.toString(),
          AppRoutes.login);
    });

    testWidgets('navigates to home when Continue as Guest is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Continue as Guest'));
      await tester.pumpAndSettle();

      expect(router.routerDelegate.currentConfiguration.uri.toString(),
          AppRoutes.home);
    });
  });
}

class _TestPage extends StatelessWidget {
  const _TestPage(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(label)));
  }
}