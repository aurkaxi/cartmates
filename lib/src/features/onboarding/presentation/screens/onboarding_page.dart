import 'package:cartmates/src/imports/imports.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return _OnboardingView(
      theme: theme,
      colorScheme: colorScheme,
      textTheme: textTheme,
    );
  }
}

class _OnboardingView extends StatelessWidget {
  const _OnboardingView({
    required this.theme,
    required this.colorScheme,
    required this.textTheme,
  });

  final ThemeData theme;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final cs = colorScheme;
    final tt = textTheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _BrandingSection(cs: cs, tt: tt),
                      SizedBox(height: AppSpacing.xl.h),
                      _ValueSection(cs: cs, tt: tt),
                      SizedBox(height: AppSpacing.xxxl.h),
                      _ActionButtons(cs: cs, tt: tt),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _BrandingSection extends StatelessWidget {
  const _BrandingSection({
    required this.cs,
    required this.tt,
  });

  final ColorScheme cs;
  final TextTheme tt;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 96.w,
          height: 96.w,
          decoration: BoxDecoration(
            color: cs.surfaceContainerLow,
            border: Border.all(color: cs.outlineVariant),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Center(
            child: SvgPicture.asset(
              'assets/icons/cartmates.svg',
              width: 64.w,
              height: 64.w,
            ),
          ),
        ),
        SizedBox(height: AppSpacing.md.h),
        Text(
          'cartmates',
          style: tt.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: AppSpacing.sm.h),
        Text(
          'Buy together, save together.',
          textAlign: TextAlign.center,
          style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.cs,
    required this.tt,
  });

  final ColorScheme cs;
  final TextTheme tt;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppButton(
          label: 'Register',
          onPressed: () => context.push(AppRoutes.signup),
          variant: ButtonVariant.primary,
          height: ButtonSize.large,
          isFullWidth: true,
        ),
        SizedBox(height: AppSpacing.sm.h),
        AppButton(
          label: 'Log In',
          onPressed: () => context.push(AppRoutes.login),
          variant: ButtonVariant.secondary,
          height: ButtonSize.large,
          isFullWidth: true,
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
    );
  }
}

class _ValueSection extends StatelessWidget {
  const _ValueSection({
    required this.cs,
    required this.tt,
  });

  final ColorScheme cs;
  final TextTheme tt;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ValueCard(
          title: 'Save on Product Cost',
          subtitle: 'Team up to unlock bulk tier discounts.',
          cs: cs,
          tt: tt,
        ),
        SizedBox(height: AppSpacing.sm.h),
        _ValueCard(
          title: 'Save on Delivery',
          subtitle: 'Split shipping fees with your campus community.',
          cs: cs,
          tt: tt,
        )
      ],
    );
  }
}

class _ValueCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final ColorScheme cs;
  final TextTheme tt;

  const _ValueCard({
    required this.title,
    required this.subtitle,
    required this.cs,
    required this.tt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md.r),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        border: Border.all(color: cs.outlineVariant),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: tt.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: cs.onSurface,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: tt.bodyMedium?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
