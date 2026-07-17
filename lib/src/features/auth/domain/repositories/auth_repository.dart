import 'package:cartmates/src/features/auth/domain/entities/auth_user.dart';
import 'package:fpdart/fpdart.dart';

abstract class AuthRepository {
  /// Login with username and password
  Future<Either<String, AuthUser>> login(String username, String password);

  /// Register a new user
  Future<Either<String, AuthUser>> register({
    required String username,
    required String email,
    required String password,
    required String universityRegNo,
  });

  /// Forget password
  Future<Either<String, void>> forgotPassword({required String email});

  /// Get current authenticated user
  Future<Either<String, AuthUser?>> getCurrentUser();

  /// Logout current user
  Future<Either<String, void>> logout();
}
