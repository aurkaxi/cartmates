import 'package:cartmates/src/features/auth/presentation/providers/auth_provider.dart';
import 'package:cartmates/src/imports/imports.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(currentUserProvider);
    final isLoading = authState.isLoading;

    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    Future<void> handleLogin() async {
      if (!(_formKey.currentState?.validate() ?? false)) return;

      await ref.read(currentUserProvider.notifier).login(
            _usernameController.text,
            _passwordController.text,
          );
    }

    Future<void> handleRegister() async {
      context.go(AppRoutes.signup);
    }

    return _LoginView(
      formKey: _formKey,
      usernameController: _usernameController,
      passwordController: _passwordController,
      obscurePassword: _obscurePassword,
      isLoading: isLoading,
      onToggleObscure: () =>
          setState(() => _obscurePassword = !_obscurePassword),
      onLogin: handleLogin,
      onRegister: handleRegister,
      cs: cs,
      tt: tt,
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView({
    required this.formKey,
    required this.usernameController,
    required this.passwordController,
    required this.obscurePassword,
    required this.isLoading,
    required this.onToggleObscure,
    required this.onLogin,
    required this.onRegister,
    required this.cs,
    required this.tt,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final bool isLoading;
  final VoidCallback onToggleObscure;
  final VoidCallback onLogin;
  final VoidCallback onRegister;
  final ColorScheme cs;
  final TextTheme tt;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.lg.w),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8.h),
                Text(
                  'Welcome Back',
                  style: tt.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: cs.onSurface,
                    fontSize: 28.sp,
                  ),
                ),
                SizedBox(height: 32.h),
                _AuthTextField(
                  controller: usernameController,
                  label: 'Username',
                  hint: 'student_name',
                  enabled: !isLoading,
                  cs: cs,
                  tt: tt,
                  key: const Key('username_field'),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Username is required';
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                _AuthTextField(
                  controller: passwordController,
                  label: 'Password',
                  hint: '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022',
                  obscureText: obscurePassword,
                  enabled: !isLoading,
                  cs: cs,
                  tt: tt,
                  key: const Key('password_field'),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: cs.onSurfaceVariant,
                    ),
                    onPressed: onToggleObscure,
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Password is required';
                    if (v.length < 6)
                      return 'Password must be at least 6 characters';
                    return null;
                  },
                ),
                AppButton(
                  label: 'Log In',
                  onPressed: isLoading ? null : onLogin,
                  variant: ButtonVariant.primary,
                  height: ButtonSize.large,
                  isFullWidth: true,
                  isLoading: isLoading,
                  key: const Key('login_button'),
                ),
                SizedBox(height: 16.h),
                AppButton(
                  label: 'Register',
                  onPressed: isLoading ? null : onRegister,
                  variant: ButtonVariant.outline,
                  height: ButtonSize.large,
                  isFullWidth: true,
                  key: const Key('register_button'),
                ),
                SizedBox(height: 16.h),
                AppButton(
                  label: 'Continue as Guest',
                  onPressed: () => context.go(AppRoutes.home),
                  variant: ButtonVariant.ghost,
                  height: ButtonSize.large,
                  isFullWidth: true,
                  textColor: cs.onSurfaceVariant,
                ),
                SizedBox(height: 32.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthTextField extends StatelessWidget {
  const _AuthTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.enabled,
    required this.cs,
    required this.tt,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final bool enabled;
  final ColorScheme cs;
  final TextTheme tt;
  final bool obscureText;
  final Widget? suffixIcon;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: tt.labelLarge?.copyWith(
            color: cs.onSurface,
            fontWeight: FontWeight.w500,
            fontSize: 12.sp,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          enabled: enabled,
          obscureText: obscureText,
          validator: validator,
          style: tt.bodyLarge?.copyWith(color: cs.onSurface),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: tt.bodyLarge
                ?.copyWith(color: cs.onSurfaceVariant.withValues(alpha: 0.5)),
            filled: true,
            fillColor: cs.surfaceContainerHighest.withValues(alpha: 0.3),
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: cs.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: cs.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: cs.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: cs.error),
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          ),
        ),
      ],
    );
  }
}