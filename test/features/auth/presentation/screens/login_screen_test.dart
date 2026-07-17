import 'package:cartmates/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:cartmates/src/features/auth/presentation/providers/auth_provider.dart';
import 'package:cartmates/src/features/auth/presentation/screens/login_screen.dart';
import 'package:cartmates/src/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/src/framework.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('LoginScreen', () {
    late GoRouter router;
    late MockAuthRepository mockRepository;
    late List<Override> overrides;

    setUpAll(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      // Set a larger test window size to accommodate the full login page
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
      mockRepository = MockAuthRepository();
      router = GoRouter(
        initialLocation: AppRoutes.onboarding,
        routes: [
          GoRoute(
            path: AppRoutes.onboarding,
            builder: (context, state) => const Scaffold(body: Text('Onboarding')),
          ),
          GoRoute(
            path: AppRoutes.login,
            builder: (context, state) => const LoginScreen(),
          ),
          GoRoute(
            path: AppRoutes.signup,
            builder: (context, state) => const Scaffold(body: Text('Signup')),
          ),
        ],
      );
      overrides = [
        authRepositoryProvider.overrideWithValue(mockRepository),
      ];
    });

    Widget createTestWidget() {
      return ProviderScope(
        overrides: overrides,
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

    testWidgets('renders login screen with all elements',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      router.go(AppRoutes.login);
      await tester.pumpAndSettle();

      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.byKey(const Key('username_field')), findsOneWidget);
      expect(find.byKey(const Key('password_field')), findsOneWidget);
      expect(find.byKey(const Key('login_button')), findsOneWidget);
      expect(find.byKey(const Key('register_button')), findsOneWidget);
    });

    testWidgets('shows validation errors when fields are empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      router.go(AppRoutes.login);
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();

      expect(find.text('Username is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('shows validation error for short password',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      router.go(AppRoutes.login);
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(const Key('username_field')), 'testuser');
      await tester.enterText(find.byKey(const Key('password_field')), '123');
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();

      expect(
          find.text('Password must be at least 6 characters'), findsOneWidget);
    });

    testWidgets('toggles password visibility when icon is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      router.go(AppRoutes.login);
      await tester.pumpAndSettle();

      // Initially visibility off icon should be visible (password obscured)
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      expect(find.byIcon(Icons.visibility), findsNothing);

      // Tap visibility toggle - should show visibility icon
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off), findsNothing);

      // Tap again - should show visibility_off icon
      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      expect(find.byIcon(Icons.visibility), findsNothing);
    });

    testWidgets('navigates to signup when register button is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      router.go(AppRoutes.login);
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('register_button')));
      await tester.pumpAndSettle();

      expect(router.routerDelegate.currentConfiguration.uri.toString(),
          AppRoutes.signup);
    });

    testWidgets('valid form shows no errors', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      router.go(AppRoutes.login);
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(const Key('username_field')), 'testuser');
      await tester.enterText(
          find.byKey(const Key('password_field')), 'password123');
      await tester.pumpAndSettle();

      expect(find.text('Username is required'), findsNothing);
      expect(find.text('Password is required'), findsNothing);
      expect(find.text('Password must be at least 6 characters'), findsNothing);
    });
  });
}