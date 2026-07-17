import 'package:cartmates/src/features/auth/domain/entities/auth_user.dart';

/// Mock datasource with hardcoded users for prototype
class AuthLocalDatasource {
  // Hardcoded users for prototype
  static const Map<String, Map<String, dynamic>> _users = {
    'regular_user': {
      'password': 'regular_pass',
      'email': 'regular@university.edu',
      'universityRegNo': '2023-REG-001',
      'role': 'regular',
      'approvalStatus': 'approved',
    },
    'cr_user': {
      'password': 'cr_pass',
      'email': 'cr@university.edu',
      'universityRegNo': '2023-REG-002',
      'role': 'campaignRunner',
      'approvalStatus': 'approved',
    },
    'admin': {
      'password': 'admin',
      'email': 'admin@university.edu',
      'universityRegNo': '2023-REG-003',
      'role': 'admin',
      'approvalStatus': 'approved',
    },
  };

  /// Validate login credentials
  /// Returns user if valid, null otherwise
  AuthUser? validateLogin(String username, String password) {
    final userData = _users[username];
    if (userData == null) return null;
    
    if (userData['password'] != password) return null;

    return _createUserFromData(username, userData);
  }

  /// Register a new user (for prototype, just validate format)
  /// In production, this would call a backend API
  AuthUser registerUser({
    required String username,
    required String email,
    required String password,
    required String universityRegNo,
  }) {
    // For prototype: create a new user with pending approval
    return AuthUser(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      username: username,
      email: email,
      universityRegNo: universityRegNo,
      role: UserRole.regular,
      approvalStatus: ApprovalStatus.pending,
    );
  }

  /// Helper to create user from data
  static AuthUser _createUserFromData(String username, Map<String, dynamic> data) {
    final roleStr = data['role'] as String;
    final approvalStr = data['approvalStatus'] as String;

    final role = roleStr == 'campaignRunner'
        ? UserRole.campaignRunner
        : roleStr == 'admin'
            ? UserRole.admin
            : UserRole.regular;

    final approvalStatus = approvalStr == 'approved'
        ? ApprovalStatus.approved
        : approvalStr == 'rejected'
            ? ApprovalStatus.rejected
            : ApprovalStatus.pending;

    return AuthUser(
      id: 'user_$username',
      username: username,
      email: data['email'] as String,
      universityRegNo: data['universityRegNo'] as String,
      role: role,
      approvalStatus: approvalStatus,
    );
  }
}
