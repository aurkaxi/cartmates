import 'package:cartmates/src/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:cartmates/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:cartmates/src/features/auth/domain/entities/auth_user.dart';
import 'package:cartmates/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:cartmates/src/imports/packages_imports.dart';

/// Auth repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final datasource = AuthLocalDatasource();
  return AuthRepositoryImpl(localDatasource: datasource);
});

/// Current authenticated user state
final currentUserProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<AuthUser?>>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});

class AuthNotifier extends StateNotifier<AsyncValue<AuthUser?>> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> login(String username, String password) async {
    state = const AsyncValue.loading();
    final result = await _repository.login(username, password);
    result.fold(
      (error) => state = AsyncValue.error(error, StackTrace.current),
      (user) => state = AsyncValue.data(user),
    );
  }

  Future<void> register({
    required String username,
    required String email,
    required String password,
    required String universityRegNo,
  }) async {
    state = const AsyncValue.loading();
    final result = await _repository.register(
      username: username,
      email: email,
      password: password,
      universityRegNo: universityRegNo,
    );
    result.fold(
      (error) => state = AsyncValue.error(error, StackTrace.current),
      (user) => state = AsyncValue.data(user),
    );
  }

  Future<void> forgotPassword({required String email}) async {
    state = const AsyncValue.loading();
    final result = await _repository.forgotPassword(email: email);
    result.fold(
      (error) => state = AsyncValue.error(error, StackTrace.current),
      (_) => state = const AsyncValue.data(null),
    );
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    final result = await _repository.logout();
    result.fold(
      (error) => state = AsyncValue.error(error, StackTrace.current),
      (_) => state = const AsyncValue.data(null),
    );
  }
}
