import 'package:cartmates/src/imports/imports.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.lg.w),
          child: Column(
            spacing: 32.h,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 96.w,
                    height: 96.h,
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Center(
                      child: Text('🛒', style: TextStyle(fontSize: 48.sp)),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'cartmates',
                    style: tt.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.5,
                      color: cs.onSurface,
                      fontSize: 28.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Buy together, save together.',
                    style: tt.bodyLarge?.copyWith(
                      color: cs.onSurfaceVariant,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  _FeatureCard(
                    icon: '💰',
                    title: 'Save on Product Cost',
                    subtitle: 'Team up to unlock bulk tier discounts.',
                    cs: cs,
                    tt: tt,
                  ),
                  SizedBox(height: 12.h),
                  _FeatureCard(
                    icon: '🚚',
                    title: 'Save on Delivery',
                    subtitle: 'Split shipping fees with your campus community.',
                    cs: cs,
                    tt: tt,
                  ),
                ],
              ),
              Column(
                children: [
                  AppButton(
                    label: 'Register',
                    onPressed: () => context.go(AppRoutes.signup),
                    variant: ButtonVariant.primary,
                    height: ButtonSize.large,
                    isFullWidth: true,
                  ),
                  SizedBox(height: 12.h),
                  AppButton(
                    label: 'Log In',
                    onPressed: () => context.go(AppRoutes.login),
                    variant: ButtonVariant.secondary,
                    height: ButtonSize.large,
                    isFullWidth: true,
                  ),
                  SizedBox(height: 12.h),
                  AppButton(
                    label: 'Continue as Guest',
                    onPressed: () => context.go(AppRoutes.home),
                    variant: ButtonVariant.ghost,
                    height: ButtonSize.large,
                    isFullWidth: true,
                    textColor: cs.onSurfaceVariant,
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.cs,
    required this.tt,
  });

  final String icon;
  final String title;
  final String subtitle;
  final ColorScheme cs;
  final TextTheme tt;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
        border: Border.all(color: cs.outlineVariant),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: TextStyle(fontSize: 24.sp)),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: tt.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: cs.onSurface,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: tt.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                    fontSize: 12.sp,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
