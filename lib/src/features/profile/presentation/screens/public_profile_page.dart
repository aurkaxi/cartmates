import 'package:cartmates/src/imports/imports.dart';
import 'package:cartmates/src/features/deals/domain/entities/deal.dart';
import 'package:cartmates/src/features/profile/domain/entities/profile.dart';
import 'package:cartmates/src/features/profile/presentation/providers/profile_provider.dart';

class PublicProfilePage extends ConsumerWidget {
  final String userId;

  const PublicProfilePage({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = context.theme.colorScheme;
    final publicAsync = ref.watch(publicProfileProvider(userId));

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            size: 24.r,
          ),
        ),
        title: Text(
          'Profile',
          style: context.theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: publicAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Failed to load profile',
                  style: context.theme.textTheme.bodyMedium),
              SizedBox(height: AppSpacing.md.h),
              AppButton(
                label: 'Retry',
                onPressed: () => ref.invalidate(publicProfileProvider(userId)),
                variant: ButtonVariant.outline,
                height: ButtonSize.small,
              ),
            ],
          ),
        ),
        data: (publicProfile) => SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
          child: Column(
            children: [
              SizedBox(height: AppSpacing.xl.h),
              _PublicProfileHeader(profile: publicProfile.profile),
              SizedBox(height: AppSpacing.xl.h),
              _PublicStatsSection(profile: publicProfile.profile),
              if (publicProfile.hostedDeals.isNotEmpty) ...[
                SizedBox(height: AppSpacing.xl.h),
                _DealHorizontalList(
                  title: 'Currently Hosting',
                  deals: publicProfile.hostedDeals,
                ),
              ],
              if (publicProfile.joinedDeals.isNotEmpty) ...[
                SizedBox(height: AppSpacing.xl.h),
                _DealHorizontalList(
                  title: 'Joined Deals',
                  deals: publicProfile.joinedDeals,
                ),
              ],
              SizedBox(height: AppSpacing.xl.h),
              _PublicContactSection(profile: publicProfile.profile),
              SizedBox(height: AppSpacing.xl.h),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Profile Header ───────────────────────────────────────────────────────────

class _PublicProfileHeader extends StatelessWidget {
  final UserProfile profile;

  const _PublicProfileHeader({required this.profile});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Column(
      children: [
        GestureDetector(
          onTap: () => _showAvatarFullscreen(context, profile.photoUrl),
          child: Container(
            width: 96.r,
            height: 96.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: cs.outlineVariant, width: 2),
            ),
            child: ClipOval(
              child: profile.photoUrl != null
                  ? AppCachedImage(
                      imageUrl: profile.photoUrl!,
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
            child: AppCachedImage(
              imageUrl: imageUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.contain,
              useSkeleton: false,
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

class _PublicStatsSection extends StatelessWidget {
  final UserProfile profile;

  const _PublicStatsSection({required this.profile});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final successColor = context.theme.extension<AppColorsExtension>()?.success;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(title: 'Activity'),
        SizedBox(height: AppSpacing.md.h),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _StatCard(
                  label: 'Joined',
                  value: '${profile.dealsJoined}',
                  icon: HugeIcons.strokeRoundedShoppingCart02,
                ),
              ),
              SizedBox(width: AppSpacing.md.w),
              Expanded(
                child: _StatCard(
                  label: 'Hosted',
                  value: '${profile.dealsHosted}',
                  sublabel: '${profile.dealsHostedSuccess} success',
                  icon: HugeIcons.strokeRoundedMegaphone01,
                  sublabelColor: successColor,
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
                  label: 'Failed',
                  value: '${profile.dealsHostedFailed}',
                  icon: HugeIcons.strokeRoundedCancel01,
                  valueColor: cs.error,
                ),
              ),
              SizedBox(width: AppSpacing.md.w),
              Expanded(
                child: _StatCard(
                  label: 'Total Saved',
                  value: '৳${profile.totalSavedBdt.toStringAsFixed(0)}',
                  icon: HugeIcons.strokeRoundedSavings,
                  valueColor: cs.primary,
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

// ── Deal Horizontal List ─────────────────────────────────────────────────────

class _DealHorizontalList extends StatelessWidget {
  final String title;
  final List<SameProductDeal> deals;

  const _DealHorizontalList({required this.title, required this.deals});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: title),
        SizedBox(height: AppSpacing.md.h),
        SizedBox(
          height: 140.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: deals.length,
            separatorBuilder: (_, __) => SizedBox(width: AppSpacing.md.w),
            itemBuilder: (context, index) => _DealCard(deal: deals[index]),
          ),
        ),
      ],
    );
  }
}

class _DealCard extends StatelessWidget {
  final SameProductDeal deal;

  const _DealCard({required this.deal});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return GestureDetector(
      onTap: () {
        context.push(AppRoutes.sameProductDealDetailPath(deal.id));
      },
      child: Container(
        width: 200.w,
        decoration: BoxDecoration(
          border: Border.all(color: cs.outlineVariant),
          borderRadius: AppBorders.lg,
          color: cs.surface,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: AppCachedImage(
                imageUrl: deal.imageUrl,
                width: 200,
                height: 70.h,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(AppSpacing.sm.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    deal.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: tt.labelMedium?.copyWith(
                      color: cs.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xxs.h),
                  Text(
                    '৳${deal.currentPrice.toStringAsFixed(0)}',
                    style: tt.labelLarge?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Contact Section (Read-only) ──────────────────────────────────────────────

class _PublicContactSection extends StatelessWidget {
  final UserProfile profile;

  const _PublicContactSection({required this.profile});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(title: 'Contact'),
        SizedBox(height: AppSpacing.md.h),
        if (profile.bkashNumber != null)
          _ReadOnlyInfoRow(
            icon: HugeIcons.strokeRoundedSmartPhone01,
            label: 'bKash Number',
            value: profile.bkashNumber!,
          ),
        if (profile.bkashNumber != null && profile.contactNumber != null)
          SizedBox(height: AppSpacing.sm.h),
        if (profile.contactNumber != null)
          _ReadOnlyInfoRow(
            icon: HugeIcons.strokeRoundedCall02,
            label: 'Contact Number',
            value: profile.contactNumber!,
          ),
        if (profile.bkashNumber == null && profile.contactNumber == null)
          Text(
            'No contact info available',
            style: context.theme.textTheme.bodyMedium?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
      ],
    );
  }
}

class _ReadOnlyInfoRow extends StatelessWidget {
  final List<List<dynamic>> icon;
  final String label;
  final String value;

  const _ReadOnlyInfoRow({
    required this.icon,
    required this.label,
    required this.value,
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
      child: Row(
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.1),
              borderRadius: AppBorders.sm,
            ),
            child: HugeIcon(
              icon: icon,
              size: 20.r,
              color: cs.primary,
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
                    color: cs.onSurface,
                    fontWeight: FontWeight.w500,
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

// ── Section Header ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

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
