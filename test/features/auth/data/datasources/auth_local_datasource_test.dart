import 'package:flutter_test/flutter_test.dart';
import 'package:cartmates/src/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:cartmates/src/features/auth/domain/entities/auth_user.dart';

void main() {
  group('AuthLocalDatasource', () {
    late AuthLocalDatasource datasource;

    setUp(() {
      datasource = AuthLocalDatasource();
    });

    group('validateLogin', () {
      test('should return AuthUser for valid regular_user credentials', () {
        final user = datasource.validateLogin('regular_user', 'regular_pass');

        expect(user, isNotNull);
        expect(user!.username, 'regular_user');
        expect(user.email, 'regular@university.edu');
        expect(user.universityRegNo, '2023-REG-001');
        expect(user.role, UserRole.regular);
        expect(user.approvalStatus, ApprovalStatus.approved);
      });

      test('should return AuthUser for valid cr_user credentials', () {
        final user = datasource.validateLogin('cr_user', 'cr_pass');

        expect(user, isNotNull);
        expect(user!.username, 'cr_user');
        expect(user.email, 'cr@university.edu');
        expect(user.universityRegNo, '2023-REG-002');
        expect(user.role, UserRole.campaignRunner);
        expect(user.approvalStatus, ApprovalStatus.approved);
      });

      test('should return AuthUser for valid admin credentials', () {
        final user = datasource.validateLogin('admin', 'admin');

        expect(user, isNotNull);
        expect(user!.username, 'admin');
        expect(user.email, 'admin@university.edu');
        expect(user.universityRegNo, '2023-REG-003');
        expect(user.role, UserRole.admin);
        expect(user.approvalStatus, ApprovalStatus.approved);
      });

      test('should return null for invalid username', () {
        final user = datasource.validateLogin('nonexistent', 'password');

        expect(user, isNull);
      });

      test('should return null for correct username but wrong password', () {
        final user = datasource.validateLogin('regular_user', 'wrong_password');

        expect(user, isNull);
      });

      test('should return null for empty username', () {
        final user = datasource.validateLogin('', 'password');

        expect(user, isNull);
      });

      test('should return null for empty password', () {
        final user = datasource.validateLogin('regular_user', '');

        expect(user, isNull);
      });
    });

    group('registerUser', () {
      test('should create new AuthUser with pending approval', () {
        final user = datasource.registerUser(
          username: 'new_student',
          email: 'new@university.edu',
          password: 'password123',
          universityRegNo: '2024-NEW-001',
        );

        expect(user.username, 'new_student');
        expect(user.email, 'new@university.edu');
        expect(user.universityRegNo, '2024-NEW-001');
        expect(user.role, UserRole.regular);
        expect(user.approvalStatus, ApprovalStatus.pending);
        expect(user.id, startsWith('user_'));
      });
    });

    group('_createUserFromData', () {
      test('should map campaignRunner role correctly', () {
        // We test this indirectly through validateLogin
        final user = datasource.validateLogin('cr_user', 'cr_pass');
        expect(user!.role, UserRole.campaignRunner);
      });

      test('should map admin role correctly', () {
        final user = datasource.validateLogin('admin', 'admin');
        expect(user!.role, UserRole.admin);
      });

      test('should map regular role correctly', () {
        final user = datasource.validateLogin('regular_user', 'regular_pass');
        expect(user!.role, UserRole.regular);
      });

      test('should map approved status correctly', () {
        final user = datasource.validateLogin('regular_user', 'regular_pass');
        expect(user!.approvalStatus, ApprovalStatus.approved);
      });
    });
  });
}