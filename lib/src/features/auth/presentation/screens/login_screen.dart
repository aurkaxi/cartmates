import 'package:cartmates/src/features/auth/presentation/providers/auth_provider.dart';
import 'package:cartmates/src/imports/core_imports.dart';
import 'package:cartmates/src/imports/packages_imports.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reg = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = true;

  @override
  void dispose() {
    _reg.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);

    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    Future<void> handleLogin() async {
      if (!(_formKey.currentState?.validate() ?? false)) return;

      ref.read(authControllerProvider.notifier).login(
            context: context,
            reg: _reg.text,
            password: _passwordController.text,
          );
    }

    return _LoginView(
      formKey: _formKey,
      regController: _reg,
      passwordController: _passwordController,
      obscurePassword: _obscurePassword,
      rememberMe: _rememberMe,
      onToggleRememberMe: (value) => setState(() => _rememberMe = !_rememberMe),
      isLoading: isLoading,
      onToggleObscure: () =>
          setState(() => _obscurePassword = !_obscurePassword),
      onLogin: handleLogin,
      cs: cs,
      tt: tt,
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView({
    required this.formKey,
    required this.regController,
    required this.passwordController,
    required this.obscurePassword,
    required this.rememberMe,
    required this.onToggleRememberMe,
    required this.isLoading,
    required this.onToggleObscure,
    required this.onLogin,
    required this.cs,
    required this.tt,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController regController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final bool rememberMe;
  final ValueChanged<bool?> onToggleRememberMe;
  final bool isLoading;
  final VoidCallback onToggleObscure;
  final VoidCallback onLogin;
  final ColorScheme cs;
  final TextTheme tt;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome Back',
                  style:
                      tt.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: AppSpacing.sm.h),
                Text(
                  'Sign in to coordinate your next group buy.',
                  textAlign: TextAlign.center,
                  style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                ),
                SizedBox(height: AppSpacing.xxxl.h),
                // Form Card
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      AppTextField(
                        controller: regController,
                        enabled: !isLoading,
                        label: 'Registration No.',
                        prefixIcon: const Icon(Icons.numbers),
                        validator: (v) {
                          if (AppUtils.isBlank(v)) {
                            return 'Registration No. is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: AppSpacing.md.h),
                      AppTextField(
                        controller: passwordController,
                        enabled: !isLoading,
                        label: 'Password',
                        obscureText: obscurePassword,
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: onToggleObscure,
                        ),
                        validator: (v) {
                          if (AppUtils.isBlank(v)) {
                            return 'Password is required';
                          }
                          if (v!.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: AppSpacing.sm.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            spacing: 5.w,
                            children: [
                              SizedBox(
                                width: 20.w,
                                height: 20.h,
                                child: Checkbox(
                                  value: rememberMe,
                                  onChanged: onToggleRememberMe,
                                ),
                              ),
                              Text(
                                'Remember Me',
                                style: tt.bodySmall
                                    ?.copyWith(color: cs.onSurfaceVariant),
                              ),
                            ],
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: () {
                              context.push(AppRoutes.forgotPassword);
                            },
                            child: Text(
                              'Forgot Password?',
                              style: tt.bodySmall?.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.lg.h),
                      AppButton(
                        label: 'Sign In',
                        isLoading: isLoading,
                        onPressed: isLoading ? null : onLogin,
                        width: ButtonSize.large,
                        isFullWidth: true,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.md.h),
                InkWell(
                  onTap: () {
                    context.push(AppRoutes.signup);
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Don\'t have an account? ',
                      style:
                          tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                      children: [
                        TextSpan(
                          text: 'Sign Up',
                          style: TextStyle(
                            color: cs.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.sm.h),
                AppButton(
                  label: 'Continue as Guest',
                  onPressed: () => context.go(AppRoutes.deals),
                  variant: ButtonVariant.ghost,
                  height: ButtonSize.large,
                  isFullWidth: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
