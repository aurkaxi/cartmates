import 'package:flutter_test/flutter_test.dart';
import 'package:cartmates/src/features/auth/domain/entities/user.dart';
import 'package:cartmates/src/features/auth/domain/entities/auth_user.dart';

void main() {
  group('AppUser', () {
    test('should create AppUser with all fields', () {
      const user = AppUser(
        id: '123',
        email: 'test@example.com',
        name: 'Test User',
        photoUrl: 'https://example.com/photo.jpg',
      );

      expect(user.id, '123');
      expect(user.email, 'test@example.com');
      expect(user.name, 'Test User');
      expect(user.photoUrl, 'https://example.com/photo.jpg');
    });

    test('should create AppUser with minimal fields', () {
      const user = AppUser(
        id: '123',
        email: 'test@example.com',
      );

      expect(user.id, '123');
      expect(user.email, 'test@example.com');
      expect(user.name, isNull);
      expect(user.photoUrl, isNull);
    });

    test('should be equal when all fields match', () {
      const user1 = AppUser(id: '1', email: 'a@b.com', name: 'User');
      const user2 = AppUser(id: '1', email: 'a@b.com', name: 'User');

      expect(user1, equals(user2));
      expect(user1.hashCode, equals(user2.hashCode));
    });

    test('should not be equal when fields differ', () {
      const user1 = AppUser(id: '1', email: 'a@b.com');
      const user2 = AppUser(id: '2', email: 'a@b.com');

      expect(user1, isNot(equals(user2)));
    });

    test('toString should contain all fields', () {
      const user = AppUser(id: '1', email: 'a@b.com', name: 'User', photoUrl: 'photo.jpg');
      final str = user.toString();

      expect(str, contains('AppUser'));
      expect(str, contains('1'));
      expect(str, contains('a@b.com'));
      expect(str, contains('User'));
      expect(str, contains('photo.jpg'));
    });
  });

  group('AuthUser', () {
    test('should create AuthUser with all fields', () {
      const user = AuthUser(
        id: 'user_123',
        username: 'student_name',
        email: 'student@university.edu',
        universityRegNo: '2023-XYZ-123',
        role: UserRole.regular,
        approvalStatus: ApprovalStatus.approved,
      );

      expect(user.id, 'user_123');
      expect(user.username, 'student_name');
      expect(user.email, 'student@university.edu');
      expect(user.universityRegNo, '2023-XYZ-123');
      expect(user.role, UserRole.regular);
      expect(user.approvalStatus, ApprovalStatus.approved);
    });

    test('should create AuthUser with campaign runner role', () {
      const user = AuthUser(
        id: 'user_456',
        username: 'cr_user',
        email: 'cr@university.edu',
        universityRegNo: '2023-XYZ-456',
        role: UserRole.campaignRunner,
        approvalStatus: ApprovalStatus.pending,
      );

      expect(user.role, UserRole.campaignRunner);
      expect(user.approvalStatus, ApprovalStatus.pending);
    });

    test('should create AuthUser with admin role', () {
      const user = AuthUser(
        id: 'user_789',
        username: 'admin',
        email: 'admin@university.edu',
        universityRegNo: '2023-XYZ-789',
        role: UserRole.admin,
        approvalStatus: ApprovalStatus.approved,
      );

      expect(user.role, UserRole.admin);
    });

    test('should be equal when all fields match', () {
      const user1 = AuthUser(
        id: '1',
        username: 'user',
        email: 'a@b.com',
        universityRegNo: '123',
        role: UserRole.regular,
        approvalStatus: ApprovalStatus.approved,
      );
      const user2 = AuthUser(
        id: '1',
        username: 'user',
        email: 'a@b.com',
        universityRegNo: '123',
        role: UserRole.regular,
        approvalStatus: ApprovalStatus.approved,
      );

      expect(user1, equals(user2));
    });

    test('should not be equal when fields differ', () {
      const user1 = AuthUser(
        id: '1',
        username: 'user',
        email: 'a@b.com',
        universityRegNo: '123',
        role: UserRole.regular,
        approvalStatus: ApprovalStatus.approved,
      );
      const user2 = AuthUser(
        id: '2',
        username: 'user',
        email: 'a@b.com',
        universityRegNo: '123',
        role: UserRole.regular,
        approvalStatus: ApprovalStatus.approved,
      );

      expect(user1, isNot(equals(user2)));
    });
  });

  group('UserRole', () {
    test('should have all expected values', () {
      expect(UserRole.values, containsAll([
        UserRole.regular,
        UserRole.campaignRunner,
        UserRole.admin,
      ]));
    });
  });

  group('ApprovalStatus', () {
    test('should have all expected values', () {
      expect(ApprovalStatus.values, containsAll([
        ApprovalStatus.pending,
        ApprovalStatus.approved,
        ApprovalStatus.rejected,
      ]));
    });
  });
}