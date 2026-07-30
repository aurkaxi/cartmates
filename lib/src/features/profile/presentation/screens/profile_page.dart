import 'dart:io';
import 'package:cartmates/src/imports/imports.dart';
import 'package:cartmates/src/features/profile/domain/entities/profile.dart';
import 'package:cartmates/src/features/profile/presentation/providers/profile_provider.dart';
import 'package:cartmates/src/features/auth/presentation/providers/session_provider.dart';
import 'package:cartmates/src/features/profile/presentation/widgets/profile_edit_sheet.dart';

bool _isLocalPath(String url) => url.startsWith('/') || url.startsWith('file:');

Widget _profileImage(String? url,
    {double? width, double? height, BoxFit fit = BoxFit.cover}) {
  if (url == null || url.isEmpty) {
    return const ColoredBox(color: Colors.transparent);
  }
  if (_isLocalPath(url)) {
    return Image.file(
      File(url),
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) => const ColoredBox(color: Colors.transparent),
    );
  }
  return AppCachedImage(
    imageUrl: url,
    width: width,
    height: height,
    fit: fit,
  );
}

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tt = context.theme.textTheme;
    final profileAsync = ref.watch(profileProvider);

    return SafeArea(
      child: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Failed to load profile', style: tt.bodyMedium),
              SizedBox(height: AppSpacing.md.h),
              AppButton(
                label: 'Retry',
                onPressed: () => ref.invalidate(profileProvider),
                variant: ButtonVariant.outline,
                height: ButtonSize.small,
              ),
            ],
          ),
        ),
        data: (profile) => RefreshIndicator(
          onRefresh: () => ref.read(profileProvider.notifier).refresh(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
            child: Column(
              children: [
                SizedBox(height: AppSpacing.xl.h),
                _ProfileHeader(profile: profile, ref: ref),
                SizedBox(height: AppSpacing.xl.h),
                _StatsSection(profile: profile),
                SizedBox(height: AppSpacing.xl.h),
                _ContactInfoSection(profile: profile),
                SizedBox(height: AppSpacing.xl.h),
                _LogoutButton(ref: ref),
                SizedBox(height: AppSpacing.xl.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Profile Header ───────────────────────────────────────────────────────────

class _ProfileHeader extends StatelessWidget {
  final UserProfile profile;
  final WidgetRef ref;

  const _ProfileHeader({required this.profile, required this.ref});

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
    );
    if (image != null) {
      await ref.read(profileProvider.notifier).updateProfile(
            photoUrl: image.path,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Column(
      children: [
        GestureDetector(
          onTap: () => _showAvatarFullscreen(context, profile.photoUrl),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 96.r,
                height: 96.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: cs.outlineVariant, width: 2),
                ),
                child: ClipOval(
                  child: profile.photoUrl != null
                      ? _profileImage(
                          profile.photoUrl,
                          width: 96,
                          height: 96,
                          fit: BoxFit.cover,
                        )
                      : ColoredBox(
                          color: cs.primaryContainer,
                          child: Icon(
                            Icons.person,
                            size: 48.r,
                            color: cs.onPrimaryContainer,
                          ),
                        ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: -4,
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 32.r,
                    height: 32.r,
                    decoration: BoxDecoration(
                      color: cs.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: cs.surface, width: 2),
                    ),
                    child: Icon(
                      Icons.camera_alt_outlined,
                      size: 16.r,
                      color: cs.onPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.md.h),
        Text(
          profile.name ?? 'No name',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
            color: cs.onSurface,
          ),
        ),
        SizedBox(height: AppSpacing.xs.h),
        Text(
          profile.email,
          style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
        ),
        SizedBox(height: AppSpacing.sm.h),
        _ReputationBadge(points: profile.reputationPoints),
      ],
    );
  }

  void _showAvatarFullscreen(BuildContext context, String? imageUrl) {
    if (imageUrl == null) return;
    showDialog<void>(
      context: context,
      builder: (_) => Dialog(
        insetPadding: EdgeInsets.all(AppSpacing.md.r),
        backgroundColor: Colors.black,
        shape: const RoundedRectangleBorder(borderRadius: AppBorders.lg),
        child: ClipRRect(
          borderRadius: AppBorders.lg,
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 4,
            child: _profileImage(
              imageUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Reputation Badge ─────────────────────────────────────────────────────────

class _ReputationBadge extends StatelessWidget {
  final int points;

  const _ReputationBadge({required this.points});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.ms.w,
        vertical: AppSpacing.xs.h,
      ),
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.1),
        borderRadius: AppBorders.full,
        border: Border.all(color: cs.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          HugeIcon(
            icon: HugeIcons.strokeRoundedStar,
            size: 14.r,
            color: cs.primary,
          ),
          SizedBox(width: AppSpacing.xxs.w),
          Text(
            '$points pts',
            style: tt.labelLarge?.copyWith(
              color: cs.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stats Section ────────────────────────────────────────────────────────────

class _StatsSection extends StatelessWidget {
  final UserProfile profile;

  const _StatsSection({required this.profile});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final successColor = context.theme.extension<AppColorsExtension>()?.success;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(title: 'Activity'),
        SizedBox(height: AppSpacing.md.h),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _StatCard(
                  label: 'Total Saved',
                  value: '৳${profile.totalSavedBdt.toStringAsFixed(0)}',
                  icon: HugeIcons.strokeRoundedSavings,
                  valueColor: cs.primary,
                ),
              ),
              SizedBox(width: AppSpacing.md.w),
              Expanded(
                child: _StatCard(
                  label: 'Joined',
                  value: '${profile.dealsJoined}',
                  icon: HugeIcons.strokeRoundedShoppingCart02,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.md.h),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _StatCard(
                  label: 'Hosted',
                  value: '${profile.dealsHosted}',
                  sublabel: '${profile.dealsHostedSuccess} success',
                  icon: HugeIcons.strokeRoundedMegaphone01,
                  sublabelColor: successColor,
                ),
              ),
              SizedBox(width: AppSpacing.md.w),
              Expanded(
                child: _StatCard(
                  label: 'Failed',
                  value: '${profile.dealsHostedFailed}',
                  icon: HugeIcons.strokeRoundedCancel01,
                  valueColor: cs.error,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? sublabel;
  final List<List<dynamic>> icon;
  final Color? valueColor;
  final Color? sublabelColor;

  const _StatCard({
    required this.label,
    required this.value,
    this.sublabel,
    required this.icon,
    this.valueColor,
    this.sublabelColor,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Container(
      padding: EdgeInsets.all(AppSpacing.md.r),
      decoration: BoxDecoration(
        border: Border.all(color: cs.outlineVariant),
        borderRadius: AppBorders.lg,
        color: cs.surface,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  label,
                  style: tt.labelMedium?.copyWith(color: cs.onSurfaceVariant),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              HugeIcon(icon: icon, size: 18.r, color: cs.primary),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: valueColor ?? cs.onSurface,
                ),
              ),
              if (sublabel != null) ...[
                SizedBox(height: AppSpacing.xxs.h),
                Text(
                  sublabel!,
                  style: tt.labelSmall?.copyWith(
                    color: sublabelColor ?? cs.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

// ── Contact Info Section ─────────────────────────────────────────────────────

class _ContactInfoSection extends StatelessWidget {
  final UserProfile profile;

  const _ContactInfoSection({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(title: 'Contact'),
        SizedBox(height: AppSpacing.md.h),
        _InfoRow(
          icon: HugeIcons.strokeRoundedSmartPhone01,
          label: 'bKash Number',
          value: profile.bkashNumber ?? 'Not set',
          isSet: profile.bkashNumber != null,
          onTap: () => _showEditSheet(
            context,
            field: 'bkash',
            currentValue: profile.bkashNumber,
          ),
        ),
        SizedBox(height: AppSpacing.sm.h),
        _InfoRow(
          icon: HugeIcons.strokeRoundedCall02,
          label: 'Contact Number',
          value: profile.contactNumber ?? 'Not set',
          isSet: profile.contactNumber != null,
          onTap: () => _showEditSheet(
            context,
            field: 'contact',
            currentValue: profile.contactNumber,
          ),
        ),
      ],
    );
  }

  void _showEditSheet(
    BuildContext context, {
    required String field,
    required String? currentValue,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: AppBorders.bottomSheet,
      ),
      builder: (_) => ProfileEditSheet(
        field: field,
        currentValue: currentValue,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final List<List<dynamic>> icon;
  final String label;
  final String value;
  final bool isSet;
  final VoidCallback onTap;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.isSet,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md.r),
        decoration: BoxDecoration(
          border: Border.all(color: cs.outlineVariant),
          borderRadius: AppBorders.lg,
          color: cs.surface,
        ),
        child: Row(
          children: [
            Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                color: isSet
                    ? cs.primary.withValues(alpha: 0.1)
                    : cs.surfaceContainerHighest,
                borderRadius: AppBorders.sm,
              ),
              child: HugeIcon(
                icon: icon,
                size: 20.r,
                color: isSet ? cs.primary : cs.onSurfaceVariant,
              ),
            ),
            SizedBox(width: AppSpacing.md.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: tt.labelMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    value,
                    style: tt.bodyMedium?.copyWith(
                      color: isSet ? cs.onSurface : cs.onSurfaceVariant,
                      fontWeight: isSet ? FontWeight.w500 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            HugeIcon(
              icon: HugeIcons.strokeRoundedEdit01,
              size: 18.r,
              color: cs.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Section Title ────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: tt.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: cs.onSurface,
          ),
        ),
        SizedBox(height: AppSpacing.xs.h),
        Container(
          width: double.infinity,
          height: 1,
          color: cs.outlineVariant,
        ),
      ],
    );
  }
}

// ── Logout Button ────────────────────────────────────────────────────────────

class _LogoutButton extends StatelessWidget {
  final WidgetRef ref;

  const _LogoutButton({required this.ref});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return AppButton(
      label: 'Log Out',
      onPressed: () async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Log Out',
                style: tt.titleMedium?.copyWith(color: cs.onSurface)),
            content: Text('Are you sure you want to log out?',
                style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
            shape: const RoundedRectangleBorder(
              borderRadius: AppBorders.dialog,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text('Cancel', style: TextStyle(color: cs.onSurface)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(
                  'Log Out',
                  style: TextStyle(color: cs.error),
                ),
              ),
            ],
          ),
        );
        if ((confirmed ?? false) && context.mounted) {
          ref.read<SessionNotifier>(sessionProvider.notifier).logout();
        }
      },
      variant: ButtonVariant.outline,
      color: cs.error,
      textColor: cs.error,
      isFullWidth: true,
    );
  }
}
