import 'package:cartmates/src/features/auth/presentation/providers/session_provider.dart';
import 'package:cartmates/src/imports/core_imports.dart';
import 'package:cartmates/src/imports/packages_imports.dart';

class DealsPage extends ConsumerWidget {
  const DealsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final session = ref.watch(sessionProvider);
    final user = session.user;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: const AppTopBar(
        title: 'Deals',
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xl.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HugeIcon(
                icon: HugeIcons.strokeRoundedHome01,
                size: 60.sp,
                color: colorScheme.primary,
              ),
              SizedBox(height: AppSpacing.lg.h),
              Text(
                user?.name ?? user?.email ?? ('Welcome to Deals!'),
                textAlign: TextAlign.center,
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: colorScheme.onSurface,
                  fontSize: 28.sp,
                ),
              ),
              SizedBox(height: AppSpacing.md.h),
              Text(
                user != null && user.name != null
                    ? user.email
                    : ('You have successfully completed the onboarding process.'),
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
