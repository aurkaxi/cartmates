import 'package:cartmates/src/features/auth/domain/entities/auth_user.dart';

class AuthUserModel extends AuthUser {
  const AuthUserModel({
    required super.id,
    required super.username,
    required super.email,
    required super.universityRegNo,
    required super.role,
    required super.approvalStatus,
  });

  factory AuthUserModel.fromEntity(AuthUser user) => AuthUserModel(
    id: user.id,
    username: user.username,
    email: user.email,
    universityRegNo: user.universityRegNo,
    role: user.role,
    approvalStatus: user.approvalStatus,
  );
}
