import 'package:cartmates/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:cartmates/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:cartmates/src/imports/core_imports.dart';
import 'package:cartmates/src/imports/packages_imports.dart';

// Provides the single instance of AuthRepositoryImpl
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
    repository: ref.read(authRepositoryProvider),
  );
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _repository;

  AuthController({
    required AuthRepository repository,
  })  : _repository = repository,
        super(false); // loading state is false

  void login(
      {required BuildContext context,
      required String reg,
      required String password}) async {
    state = true;

    final result = await _repository.login(reg: reg, password: password);

    state = false;
    result.fold(
      (failure) {
        if (context.mounted) {
          showToast(context, message: failure.message, status: 'error');
        }
      },
      (user) {
        if (rootContext?.mounted ?? false) {
          rootContext!.go(AppRoutes.deals);
        }
      },
    );
  }

  void signUp(
      {required BuildContext context,
      required String name,
      required String reg,
      required String email,
      required String password}) async {
    state = true;

    final result = await _repository.signUp(
        name: name, reg: reg, email: email, password: password);

    state = false;
    result.fold(
      (failure) {
        if (context.mounted) {
          showToast(context, message: failure.message, status: 'error');
        }
      },
      (user) {
        if (rootContext?.mounted ?? false) {
          rootContext!.go(AppRoutes.deals);
        }
      },
    );
  }

  void forgotPassword(
      {required BuildContext context, required String email}) async {
    state = true;

    final result = await _repository.forgotPassword(email: email);

    state = false;
    result.fold(
      (failure) {
        if (context.mounted) {
          showToast(context, message: failure.message, status: 'error');
        }
      },
      (success) {
        if (context.mounted) {
          showToast(context,
              message: 'Password reset link sent successfully',
              status: 'success');
        }
        if (context.mounted) {
          context.go(AppRoutes.login);
        }
      },
    );
  }
}
