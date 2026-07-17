import 'dart:async';

import 'package:cartmates/src/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:cartmates/src/features/auth/domain/entities/auth_user.dart';
import 'package:cartmates/src/features/auth/domain/entities/user.dart';
import 'package:cartmates/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:cartmates/src/imports/packages_imports.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDatasource localDatasource;
  final StreamController<AppUser?> _authStateController =
      StreamController<AppUser?>.broadcast();

  AuthRepositoryImpl({required this.localDatasource});

  @override
  Future<Either<String, AuthUser>> login(
      String username, String password) async {
    try {
      final user = localDatasource.validateLogin(username, password);
      if (user == null) {
        return const Left('Invalid username or password');
      }
      // TODO(backend): Call real backend API
      final appUser = AppUser(
        id: user.id,
        email: user.email,
        name: user.username,
      );
      _authStateController.add(appUser);
      return Right(user);
    } catch (e) {
      return Left('Login failed: $e');
    }
  }

  @override
  Future<Either<String, AuthUser>> register({
    required String username,
    required String email,
    required String password,
    required String universityRegNo,
  }) async {
    try {
      // Basic validation
      if (username.isEmpty ||
          email.isEmpty ||
          password.isEmpty ||
          universityRegNo.isEmpty) {
        return const Left('All fields are required');
      }

      if (password.length < 6) {
        return const Left('Password must be at least 6 characters');
      }

      if (!email.contains('@')) {
        return const Left('Please enter a valid email');
      }

      final user = localDatasource.registerUser(
        username: username,
        email: email,
        password: password,
        universityRegNo: universityRegNo,
      );

      // TODO(backend): Call real backend API to save registration
      final appUser = AppUser(
        id: user.id,
        email: user.email,
        name: user.username,
      );
      _authStateController.add(appUser);
      return Right(user);
    } catch (e) {
      return Left('Registration failed: $e');
    }
  }

  @override
  Future<Either<String, void>> forgotPassword({required String email}) async {
    try {
      // TODO(backend): Call real backend API to send password reset email
      // For now, just simulate success
      return const Right(null);
    } catch (e) {
      return Left('Failed to send password reset: $e');
    }
  }

  @override
  Future<Either<String, AuthUser?>> getCurrentUser() async {
    try {
      // TODO(backend): Fetch from secure storage or backend
      return const Right(null);
    } catch (e) {
      return Left('Failed to get current user: $e');
    }
  }

  @override
  Future<Either<String, void>> logout() async {
    try {
      _authStateController.add(null);
      // TODO(backend): Clear tokens and user data from secure storage
      return const Right(null);
    } catch (e) {
      return Left('Logout failed: $e');
    }
  }
}
