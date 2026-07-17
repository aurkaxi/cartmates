import 'package:cartmates/src/features/auth/domain/entities/auth_user.dart';
import 'package:cartmates/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:cartmates/src/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('AuthNotifier', () {
    late MockAuthRepository mockRepository;
    late AuthNotifier notifier;

    setUp(() {
      mockRepository = MockAuthRepository();
      notifier = AuthNotifier(mockRepository);
    });

    tearDown(() {
      notifier.dispose();
    });

    group('login', () {
      test('sets loading state then data on success', () async {
        const user = AuthUser(
          id: '1',
          username: 'testuser',
          email: 'test@test.com',
          universityRegNo: '2023-REG-001',
          role: UserRole.regular,
          approvalStatus: ApprovalStatus.approved,
        );
        when(() => mockRepository.login('testuser', 'password'))
            .thenAnswer((_) async => const Right(user));

        expect(notifier.state, const AsyncData<AuthUser?>(null));

        notifier.login('testuser', 'password');

        expect(notifier.state, const AsyncLoading<AuthUser?>());

        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        expect(notifier.state, const AsyncData<AuthUser?>(user));
      });

      test('sets loading state then error on failure', () async {
        when(() => mockRepository.login('testuser', 'wrong'))
            .thenAnswer((_) async => const Left('Invalid credentials'));

        expect(notifier.state, const AsyncData<AuthUser?>(null));

        notifier.login('testuser', 'wrong');

        expect(notifier.state, const AsyncLoading<AuthUser?>());

        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        expect(notifier.state, isA<AsyncError<AuthUser?>>());
      });

      test('calls repository with correct parameters', () async {
        const user = AuthUser(
          id: '1',
          username: 'testuser',
          email: 'test@test.com',
          universityRegNo: '2023-REG-001',
          role: UserRole.regular,
          approvalStatus: ApprovalStatus.approved,
        );
        when(() => mockRepository.login('testuser', 'password123'))
            .thenAnswer((_) async => const Right(user));

        notifier.login('testuser', 'password123');

        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        verify(() => mockRepository.login('testuser', 'password123')).called(1);
      });
    });

    group('register', () {
      test('sets loading state then data on success', () async {
        const user = AuthUser(
          id: '1',
          username: 'testuser',
          email: 'test@test.com',
          universityRegNo: '2023-REG-001',
          role: UserRole.regular,
          approvalStatus: ApprovalStatus.approved,
        );
        when(() => mockRepository.register(
              username: 'testuser',
              email: 'test@test.com',
              password: 'password123',
              universityRegNo: '2023-REG-001',
            )).thenAnswer((_) async => const Right(user));

        expect(notifier.state, const AsyncData<AuthUser?>(null));

        notifier.register(
          username: 'testuser',
          email: 'test@test.com',
          password: 'password123',
          universityRegNo: '2023-REG-001',
        );

        expect(notifier.state, const AsyncLoading<AuthUser?>());

        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        expect(notifier.state, const AsyncData<AuthUser?>(user));
      });

      test('sets loading state then error on failure', () async {
        when(() => mockRepository.register(
              username: any(named: 'username'),
              email: any(named: 'email'),
              password: any(named: 'password'),
              universityRegNo: any(named: 'universityRegNo'),
            )).thenAnswer((_) async => const Left('Email already exists'));

        expect(notifier.state, const AsyncData<AuthUser?>(null));

        notifier.register(
          username: 'testuser',
          email: 'test@test.com',
          password: 'password123',
          universityRegNo: '2023-REG-001',
        );

        expect(notifier.state, const AsyncLoading<AuthUser?>());

        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        expect(notifier.state, isA<AsyncError<AuthUser?>>());
      });

      test('calls repository with correct parameters', () async {
        const user = AuthUser(
          id: '1',
          username: 'testuser',
          email: 'test@test.com',
          universityRegNo: '2023-REG-001',
          role: UserRole.regular,
          approvalStatus: ApprovalStatus.approved,
        );
        when(() => mockRepository.register(
              username: 'testuser',
              email: 'test@test.com',
              password: 'password123',
              universityRegNo: '2023-REG-001',
            )).thenAnswer((_) async => const Right(user));

        notifier.register(
          username: 'testuser',
          email: 'test@test.com',
          password: 'password123',
          universityRegNo: '2023-REG-001',
        );

        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        verify(() => mockRepository.register(
              username: 'testuser',
              email: 'test@test.com',
              password: 'password123',
              universityRegNo: '2023-REG-001',
            )).called(1);
      });
    });

    group('forgotPassword', () {
      test('sets loading state then data on success', () async {
        when(() => mockRepository.forgotPassword(email: 'test@test.com'))
            .thenAnswer((_) async => const Right(null));

        expect(notifier.state, const AsyncData<AuthUser?>(null));

        notifier.forgotPassword(email: 'test@test.com');

        expect(notifier.state, const AsyncLoading<AuthUser?>());

        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        expect(notifier.state, const AsyncData<AuthUser?>(null));
      });

      test('sets loading state then error on failure', () async {
        when(() => mockRepository.forgotPassword(email: any(named: 'email')))
            .thenAnswer((_) async => const Left('User not found'));

        expect(notifier.state, const AsyncData<AuthUser?>(null));

        notifier.forgotPassword(email: 'test@test.com');

        expect(notifier.state, const AsyncLoading<AuthUser?>());

        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        expect(notifier.state, isA<AsyncError<AuthUser?>>());
      });

      test('calls repository with correct email', () async {
        when(() => mockRepository.forgotPassword(email: 'test@test.com'))
            .thenAnswer((_) async => const Right(null));

        notifier.forgotPassword(email: 'test@test.com');

        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        verify(() => mockRepository.forgotPassword(email: 'test@test.com'))
            .called(1);
      });
    });

    group('logout', () {
      test('sets loading state then data(null) on success', () async {
        when(() => mockRepository.logout())
            .thenAnswer((_) async => const Right(null));

        notifier.state = const AsyncData<AuthUser?>(
          AuthUser(
            id: '1',
            username: 'test',
            email: 'test@test.com',
            universityRegNo: '2023-REG-001',
            role: UserRole.regular,
            approvalStatus: ApprovalStatus.approved,
          ),
        );

        final logoutFuture = notifier.logout();

        // Check loading state immediately after calling logout (before awaiting)
        expect(notifier.state, const AsyncLoading<AuthUser?>());

        await logoutFuture;

        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);

        expect(notifier.state, const AsyncData<AuthUser?>(null));
      });
    });
  });

  group('AuthProvider integration', () {
    late ProviderContainer container;
    late MockAuthRepository mockRepository;

    setUp(() {
      mockRepository = MockAuthRepository();
      container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('currentUserProvider initializes with data(null)', () {
      expect(container.read(currentUserProvider), const AsyncData<AuthUser?>(null));
    });

    test('login updates state through provider', () async {
      const user = AuthUser(
        id: '1',
        username: 'testuser',
        email: 'test@test.com',
        universityRegNo: '2023-REG-001',
        role: UserRole.regular,
        approvalStatus: ApprovalStatus.approved,
      );
      when(() => mockRepository.login('testuser', 'password'))
          .thenAnswer((_) async => const Right(user));

      container
          .read(currentUserProvider.notifier)
          .login('testuser', 'password');

      // Loading starts
      expect(container.read(currentUserProvider), const AsyncLoading<AuthUser?>());

      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      // Loading ends with data
      expect(container.read(currentUserProvider), const AsyncData<AuthUser?>(user));
    });
  });
}