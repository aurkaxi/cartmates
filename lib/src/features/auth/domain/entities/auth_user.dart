import 'package:equatable/equatable.dart';

enum UserRole { regular, campaignRunner, admin }

enum ApprovalStatus { pending, approved, rejected }

class AuthUser extends Equatable {
  final String id;
  final String username;
  final String email;
  final String universityRegNo;
  final UserRole role;
  final ApprovalStatus approvalStatus;

  const AuthUser({
    required this.id,
    required this.username,
    required this.email,
    required this.universityRegNo,
    required this.role,
    required this.approvalStatus,
  });

  @override
  List<Object?> get props => [id, username, email, universityRegNo, role, approvalStatus];
}
