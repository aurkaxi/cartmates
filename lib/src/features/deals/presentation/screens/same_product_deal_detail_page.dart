import 'package:cartmates/src/imports/imports.dart';

import '../../domain/entities/deal.dart';
import '../../domain/entities/same_product_deal_detail.dart';

class SameProductDealDetailPage extends ConsumerWidget {
  final String dealId;

  const SameProductDealDetailPage({super.key, required this.dealId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = context.theme.colorScheme;
    final detail = _getMockSameProductDetail(dealId);

    if (detail == null) {
      return Scaffold(
        backgroundColor: cs.surface,
        body: const Center(child: Text('Deal not found')),
      );
    }

    return Scaffold(
      backgroundColor: cs.surface,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SameProductHeroImage(imageUrl: detail.deal.imageUrl),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: AppSpacing.md.h),
                      _SameProductProgressSection(deal: detail.deal),
                      SizedBox(height: AppSpacing.md.h),
                      _SameProductChipsAndTitle(
                        tags: detail.categoryTags,
                        name: detail.deal.name,
                      ),
                      SizedBox(height: AppSpacing.lg.h),
                      _SameProductLogisticsCard(detail: detail),
                      SizedBox(height: AppSpacing.lg.h),
                      _SameProductTabbedSection(detail: detail),
                      SizedBox(height: 100.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _SameProductBackButton(),
          _SameProductBottomBanner(deal: detail.deal),
        ],
      ),
    );
  }
}

// ── Hero Image ──────────────────────────────────────────────────────────────

class _SameProductHeroImage extends StatelessWidget {
  final String imageUrl;

  const _SameProductHeroImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return Container(
      height: 256.h,
      width: double.infinity,
      color: cs.surfaceContainerHighest,
      child: AppCachedImage(
        imageUrl: imageUrl,
        height: 256,
        fit: BoxFit.cover,
        useSkeleton: true,
      ),
    );
  }
}

// ── Back Button ─────────────────────────────────────────────────────────────

class _SameProductBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.sm.r),
        child: GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color: cs.surface.withValues(alpha: 0.85),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedArrowLeft01,
                size: 20.r,
                color: cs.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Progress Section ────────────────────────────────────────────────────────

class _SameProductProgressSection extends StatelessWidget {
  final SameProductDeal deal;

  const _SameProductProgressSection({required this.deal});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress',
              style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
            ),
            Text(
              '${deal.qtyCurrent} / ${deal.qtyGoal} Qty',
              style: tt.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: cs.onSurface,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.sm.h),
        _SameProductProgressBar(deal: deal),
        SizedBox(height: AppSpacing.sm.h),
        _SameProductProgressLegend(deal: deal),
      ],
    );
  }
}

class _SameProductProgressBar extends StatelessWidget {
  final SameProductDeal deal;

  const _SameProductProgressBar({required this.deal});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final confirmedWidth = deal.confirmedProgress.clamp(0.0, 1.0);
    final holdWidth = deal.holdProgress.clamp(0.0, 1.0 - confirmedWidth);
    final emptyWidth = (1 - confirmedWidth - holdWidth).clamp(0.0, 1.0);

    return Container(
      height: 12.h,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: AppBorders.full,
        border: Border.all(color: cs.outlineVariant),
      ),
      child: ClipRRect(
        borderRadius: AppBorders.full,
        child: Row(
          children: [
            if (confirmedWidth > 0)
              Expanded(
                flex: (confirmedWidth * 100).round(),
                child: Container(color: cs.primary),
              ),
            if (holdWidth > 0)
              Expanded(
                flex: (holdWidth * 100).round(),
                child: Container(color: cs.tertiaryContainer),
              ),
            if (emptyWidth > 0)
              Expanded(
                flex: (emptyWidth * 100).round(),
                child: const SizedBox.shrink(),
              ),
          ],
        ),
      ),
    );
  }
}

class _SameProductProgressLegend extends StatelessWidget {
  final SameProductDeal deal;

  const _SameProductProgressLegend({required this.deal});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    final interested = deal.qtyGoal - deal.qtyCurrent;

    return Row(
      children: [
        _SameProductLegendItem(
          color: cs.primary,
          label: '${deal.confirmedQty} Confirmed',
          tt: tt,
          cs: cs,
        ),
        SizedBox(width: AppSpacing.md.w),
        _SameProductLegendItem(
          color: cs.tertiaryContainer,
          label: '${deal.holdQty} Hold',
          tt: tt,
          cs: cs,
        ),
        SizedBox(width: AppSpacing.md.w),
        _SameProductLegendItem(
          color: cs.outlineVariant,
          label: '$interested Interested',
          tt: tt,
          cs: cs,
        ),
      ],
    );
  }
}

class _SameProductLegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final TextTheme tt;
  final ColorScheme cs;

  const _SameProductLegendItem({
    required this.color,
    required this.label,
    required this.tt,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8.r,
          height: 8.r,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: AppSpacing.xxs.w),
        Text(
          label,
          style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant),
        ),
      ],
    );
  }
}

// ── Chips and Title ─────────────────────────────────────────────────────────

class _SameProductChipsAndTitle extends StatelessWidget {
  final List<String> tags;
  final String name;

  const _SameProductChipsAndTitle({
    required this.tags,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.sm.w,
          runSpacing: AppSpacing.sm.h,
          children: tags
              .map(
                (tag) => GestureDetector(
                  onTap: () {
                    // TODO: Navigate to search screen with this category
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.ms.w,
                      vertical: AppSpacing.xs.h,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: cs.outlineVariant),
                      borderRadius: AppBorders.full,
                      color: cs.surfaceContainerLow,
                    ),
                    child: Text(
                      tag,
                      style: tt.labelSmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        SizedBox(height: AppSpacing.md.h),
        Text(
          name,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            height: 1.3,
            color: cs.onSurface,
          ),
        ),
      ],
    );
  }
}

// ── Logistics Card ──────────────────────────────────────────────────────────

class _SameProductLogisticsCard extends StatelessWidget {
  final SameProductDealDetail detail;

  const _SameProductLogisticsCard({required this.detail});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: cs.outlineVariant),
        borderRadius: AppBorders.lg,
        color: cs.surface,
      ),
      child: Column(
        children: [
          _SameProductHostRow(host: detail.host),
          _SameProductDeadlinePickupGrid(
            deadline: detail.deadline,
            pickupLocation: detail.pickupLocation,
            pickupDetail: detail.pickupDetail,
          ),
          _SameProductAdditionalDetails(
            source: detail.source,
            description: detail.description,
          ),
        ],
      ),
    );
  }
}

class _SameProductHostRow extends StatelessWidget {
  final SameProductDealHostInfo host;

  const _SameProductHostRow({required this.host});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Container(
      padding: EdgeInsets.all(AppSpacing.md.r),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: cs.outlineVariant),
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: AppBorders.full,
            child: AppCachedImage(
              imageUrl: host.avatarUrl,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              borderRadius: AppBorders.full,
            ),
          ),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        host.name,
                        style: tt.labelLarge?.copyWith(
                          color: cs.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: AppSpacing.xs.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs.w,
                        vertical: 1.h,
                      ),
                      decoration: BoxDecoration(
                        color: cs.primary.withValues(alpha: 0.1),
                        borderRadius: AppBorders.xs,
                        border: Border.all(
                          color: cs.primary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Text(
                        'HOST',
                        style: tt.labelSmall?.copyWith(
                          color: cs.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 9.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.xxs.h),
                Row(
                  children: [
                    HugeIcon(
                      icon: HugeIcons.strokeRoundedStar,
                      size: 14.r,
                      color: cs.tertiary,
                    ),
                    SizedBox(width: AppSpacing.xxs.w),
                    Text(
                      '${host.reputationPoints} pts · ${host.successCount} success · ${host.failCount} fail',
                      style: tt.labelSmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          HugeIcon(
            icon: HugeIcons.strokeRoundedArrowRight01,
            size: 20.r,
            color: cs.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}

class _SameProductDeadlinePickupGrid extends StatelessWidget {
  final DateTime deadline;
  final String pickupLocation;
  final String pickupDetail;

  const _SameProductDeadlinePickupGrid({
    required this.deadline,
    required this.pickupLocation,
    required this.pickupDetail,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    final now = DateTime.now();
    final diff = deadline.difference(now);
    final daysLeft = diff.inDays;
    final hoursLeft = diff.inHours.remainder(24);

    String timerText;
    if (daysLeft > 0) {
      timerText = '$daysLeft day${daysLeft > 1 ? 's' : ''} left';
    } else if (hoursLeft > 0) {
      timerText = '$hoursLeft left';
    } else {
      timerText = 'Closing soon';
    }

    const monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final deadlineText =
        '${monthNames[deadline.month - 1]} ${deadline.day}, ${deadline.hour}:${deadline.minute.toString().padLeft(2, '0')} ${deadline.hour >= 12 ? 'PM' : 'AM'}';

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: cs.outlineVariant),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.md.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        HugeIcon(
                          icon: HugeIcons.strokeRoundedCalendar01,
                          size: 16.r,
                          color: cs.onSurfaceVariant,
                        ),
                        SizedBox(width: AppSpacing.xs.w),
                        Text(
                          'DEADLINE',
                          style: tt.labelSmall?.copyWith(
                            color: cs.onSurfaceVariant,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.xs.h),
                    Text(
                      deadlineText,
                      style: tt.labelLarge?.copyWith(
                        color: cs.onSurface,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      timerText,
                      style: tt.labelSmall?.copyWith(
                        color: cs.error,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            VerticalDivider(
              width: 1,
              color: cs.outlineVariant,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.md.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        HugeIcon(
                          icon: HugeIcons.strokeRoundedLocation01,
                          size: 16.r,
                          color: cs.onSurfaceVariant,
                        ),
                        SizedBox(width: AppSpacing.xs.w),
                        Text(
                          'PICKUP',
                          style: tt.labelSmall?.copyWith(
                            color: cs.onSurfaceVariant,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.xs.h),
                    Text(
                      pickupLocation,
                      style: tt.labelLarge?.copyWith(
                        color: cs.onSurface,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      pickupDetail,
                      style: tt.labelSmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SameProductAdditionalDetails extends StatefulWidget {
  final String source;
  final String description;

  const _SameProductAdditionalDetails({
    required this.source,
    required this.description,
  });

  @override
  State<_SameProductAdditionalDetails> createState() =>
      _SameProductAdditionalDetailsState();
}

class _SameProductAdditionalDetailsState
    extends State<_SameProductAdditionalDetails> {
  bool _expanded = false;
  bool _sourceExpanded = false;

  bool get _isUrl =>
      widget.source.startsWith('http://') ||
      widget.source.startsWith('https://');

  Future<void> _openSource() async {
    if (_isUrl) {
      try {
        final uri = Uri.parse(widget.source);
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (_) {}
    } else {
      setState(() => _sourceExpanded = !_sourceExpanded);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Material(
      color: Colors.transparent,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          onExpansionChanged: (v) => setState(() => _expanded = v),
          tilePadding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md.w,
            vertical: 0,
          ),
          childrenPadding: EdgeInsets.fromLTRB(
            AppSpacing.md.w,
            0,
            AppSpacing.md.w,
            AppSpacing.md.h,
          ),
          title: Text(
            'Additional Details',
            style: tt.labelLarge?.copyWith(
              color: cs.onSurface,
            ),
          ),
          trailing: AnimatedRotation(
            turns: _expanded ? 0.5 : 0,
            duration: AppDurations.microInteraction,
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedArrowDown01,
              size: 20.r,
              color: cs.onSurfaceVariant,
            ),
          ),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Source',
                  style: tt.labelSmall?.copyWith(
                    color: cs.onSurfaceVariant,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: AppSpacing.xs.h),
                GestureDetector(
                  onTap: _openSource,
                  child: Container(
                    padding: EdgeInsets.all(AppSpacing.sm.r),
                    decoration: BoxDecoration(
                      border: Border.all(color: cs.outlineVariant),
                      borderRadius: AppBorders.sm,
                      color: cs.surfaceContainerLow,
                    ),
                    child: Row(
                      children: [
                        HugeIcon(
                          icon: _isUrl
                              ? HugeIcons.strokeRoundedLink01
                              : HugeIcons.strokeRoundedInformationCircle,
                          size: 16.r,
                          color: cs.onSurfaceVariant,
                        ),
                        SizedBox(width: AppSpacing.sm.w),
                        Expanded(
                          child: Text(
                            widget.source,
                            maxLines: _sourceExpanded ? null : 1,
                            overflow:
                                _sourceExpanded ? null : TextOverflow.ellipsis,
                            style: tt.bodyMedium?.copyWith(
                              color: _isUrl ? cs.primary : cs.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (widget.description.isNotEmpty) ...[
                  SizedBox(height: AppSpacing.sm.h),
                  Text(
                    widget.description,
                    style: tt.bodyMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Tabbed Section ──────────────────────────────────────────────────────────

class _SameProductTabbedSection extends StatefulWidget {
  final SameProductDealDetail detail;

  const _SameProductTabbedSection({required this.detail});

  @override
  State<_SameProductTabbedSection> createState() =>
      _SameProductTabbedSectionState();
}

class _SameProductTabbedSectionState extends State<_SameProductTabbedSection> {
  int _activeTab = 0;
  static const _tabs = ['Pricing Tiers', 'Updates', 'Discussion'];

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return Column(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: cs.outlineVariant),
            ),
          ),
          child: Row(
            children: List.generate(
              _tabs.length,
              (i) => Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _activeTab = i),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.sm.h),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color:
                              _activeTab == i ? cs.primary : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      _tabs[i],
                      textAlign: TextAlign.center,
                      style: context.theme.textTheme.labelLarge?.copyWith(
                        color:
                            _activeTab == i ? cs.primary : cs.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: AppSpacing.md.h),
        if (_activeTab == 0)
          _SameProductPricingTierTimeline(
            tiers: widget.detail.pricingTiers,
          ),
        if (_activeTab == 1)
          _SameProductUpdatesTimeline(updates: widget.detail.updates),
        if (_activeTab == 2)
          _SameProductDiscussionTab(comments: widget.detail.comments),
      ],
    );
  }
}

// ── Pricing Tier Timeline ───────────────────────────────────────────────────

class _SameProductPricingTierTimeline extends StatelessWidget {
  final List<SameProductPricingTier> tiers;

  const _SameProductPricingTierTimeline({required this.tiers});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    final sorted = tiers.toList()..sort((a, b) => b.minQty.compareTo(a.minQty));

    return Column(
      children: List.generate(sorted.length * 2 - 1, (index) {
        if (index.isOdd) {
          final prevTier = sorted[(index - 1) ~/ 2];
          final isActiveOrUnlocked = prevTier.isActive || prevTier.isUnlocked;
          return Container(
            width: 2,
            height: 16.h,
            margin: EdgeInsets.only(left: 15.r),
            color: isActiveOrUnlocked ? cs.primary : cs.outlineVariant,
          );
        }
        final tierIndex = index ~/ 2;
        final tier = sorted[tierIndex];
        return _SameProductPricingTierCard(tier: tier);
      }),
    );
  }
}

class _SameProductPricingTierCard extends StatelessWidget {
  final SameProductPricingTier tier;

  const _SameProductPricingTierCard({required this.tier});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    Color bgColor;
    Color borderColor;
    Color iconBgColor;
    Color iconColor;
    IconData? iconData;

    if (tier.isActive) {
      bgColor = cs.primary.withValues(alpha: 0.08);
      borderColor = cs.primary;
      iconBgColor = cs.primary;
      iconColor = cs.onPrimary;
      iconData = Icons.play_arrow_rounded;
    } else if (tier.isUnlocked) {
      bgColor = cs.surface;
      borderColor = cs.primary;
      iconBgColor = const Color(0xFFE8F5E9);
      iconColor = const Color(0xFF2E7D32);
      iconData = Icons.check_rounded;
    } else {
      bgColor = cs.surface;
      borderColor = cs.outlineVariant;
      iconBgColor = cs.surfaceContainerHighest;
      iconColor = cs.onSurfaceVariant;
      iconData = Icons.lock_rounded;
    }

    final isLocked = !tier.isActive && !tier.isUnlocked;

    return Opacity(
      opacity: isLocked ? 0.6 : 1.0,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md.r),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(
            color: borderColor,
            width: tier.isActive ? 2 : 1,
          ),
          borderRadius: AppBorders.lg,
        ),
        child: Row(
          children: [
            Container(
              width: 32.r,
              height: 32.r,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(iconData, size: 18.r, color: iconColor),
            ),
            SizedBox(width: AppSpacing.md.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${tier.minQty}+ units',
                    style: tt.titleMedium?.copyWith(
                      color: tier.isActive ? cs.primary : cs.onSurface,
                      fontWeight:
                          tier.isActive ? FontWeight.w700 : FontWeight.w600,
                    ),
                  ),
                  if (tier.isActive)
                    Text(
                      'Active Tier',
                      style: tt.labelSmall?.copyWith(
                        color: const Color(0xFF2E7D32),
                      ),
                    ),
                  if (tier.isUnlocked && !tier.isActive)
                    Text(
                      'Reached',
                      style: tt.labelSmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
            Text(
              '\$${tier.price.toStringAsFixed(2)}',
              style: tt.titleMedium?.copyWith(
                color: tier.isActive ? cs.primary : cs.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Updates Timeline ────────────────────────────────────────────────────────

class _SameProductUpdatesTimeline extends StatelessWidget {
  final List<SameProductDealUpdate> updates;

  const _SameProductUpdatesTimeline({required this.updates});

  @override
  Widget build(BuildContext context) {
    if (updates.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.xl.h),
          child: Text(
            'No updates yet',
            style: context.theme.textTheme.bodyMedium?.copyWith(
              color: context.theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    return Column(
      children: List.generate(updates.length * 2 - 1, (index) {
        if (index.isOdd) {
          return Container(
            width: 2,
            height: 16.h,
            margin: EdgeInsets.only(left: 5.r),
            color: context.theme.colorScheme.outlineVariant,
          );
        }
        final i = index ~/ 2;
        return _SameProductUpdateCard(
          update: updates[i],
          isFirst: i == 0,
        );
      }),
    );
  }
}

class _SameProductUpdateCard extends StatelessWidget {
  final SameProductDealUpdate update;
  final bool isFirst;

  const _SameProductUpdateCard({
    required this.update,
    this.isFirst = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    final now = DateTime.now();
    final diff = now.difference(update.timestamp);
    String timeText;
    if (diff.inDays > 0) {
      timeText = '${diff.inDays}d ago';
    } else if (diff.inHours > 0) {
      timeText = '${diff.inHours}h ago';
    } else {
      timeText = '${diff.inMinutes}m ago';
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 12.r,
          height: 12.r,
          margin: EdgeInsets.only(top: 4.h),
          decoration: BoxDecoration(
            color: isFirst ? cs.primary : cs.surfaceContainerHighest,
            shape: BoxShape.circle,
            border: Border.all(
              color: isFirst ? cs.primary : cs.outlineVariant,
            ),
          ),
        ),
        SizedBox(width: AppSpacing.md.w),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(AppSpacing.md.r),
            decoration: BoxDecoration(
              color: cs.surface,
              border: Border.all(color: cs.outlineVariant),
              borderRadius: AppBorders.sm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  timeText,
                  style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant),
                ),
                SizedBox(height: AppSpacing.xs.h),
                Text(
                  update.message,
                  style: tt.bodyMedium?.copyWith(color: cs.onSurface),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Discussion Tab ──────────────────────────────────────────────────────────

class _SameProductDiscussionTab extends StatefulWidget {
  final List<SameProductDealComment> comments;

  const _SameProductDiscussionTab({required this.comments});

  @override
  State<_SameProductDiscussionTab> createState() =>
      _SameProductDiscussionTabState();
}

class _SameProductDiscussionTabState extends State<_SameProductDiscussionTab> {
  final _controller = TextEditingController();
  String? _replyingTo;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: _replyingTo != null
                      ? 'Reply to $_replyingTo...'
                      : 'Add a comment...',
                  hintStyle: tt.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: AppBorders.full,
                    borderSide: BorderSide(color: cs.outlineVariant),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppBorders.full,
                    borderSide: BorderSide(color: cs.outlineVariant),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: AppBorders.full,
                    borderSide: BorderSide(color: cs.primary),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.md.w,
                    vertical: AppSpacing.sm.h,
                  ),
                  suffixIcon: _replyingTo != null
                      ? IconButton(
                          icon: Icon(Icons.close_rounded, size: 18.r),
                          onPressed: () {
                            setState(() => _replyingTo = null);
                            _controller.clear();
                          },
                        )
                      : null,
                ),
                style: tt.bodyMedium?.copyWith(color: cs.onSurface),
              ),
            ),
            SizedBox(width: AppSpacing.sm.w),
            GestureDetector(
              onTap: () {
                _controller.clear();
                setState(() => _replyingTo = null);
              },
              child: Container(
                width: 40.r,
                height: 40.r,
                decoration: BoxDecoration(
                  color: cs.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.send_rounded,
                  size: 18.r,
                  color: cs.onPrimary,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.md.h),
        ...widget.comments.map(
          (comment) => _SameProductCommentCard(
            comment: comment,
            onReply: (authorName) {
              setState(() => _replyingTo = authorName);
              FocusScope.of(context).requestFocus(FocusNode());
            },
          ),
        ),
      ],
    );
  }
}

class _SameProductCommentCard extends StatelessWidget {
  final SameProductDealComment comment;
  final ValueChanged<String> onReply;

  const _SameProductCommentCard({
    required this.comment,
    required this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    final now = DateTime.now();
    final diff = now.difference(comment.timestamp);
    String timeText;
    if (diff.inDays > 0) {
      timeText = '${diff.inDays}d ago';
    } else if (diff.inHours > 0) {
      timeText = '${diff.inHours}h ago';
    } else {
      timeText = '${diff.inMinutes}m ago';
    }

    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.md.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: AppBorders.full,
                child: AppCachedImage(
                  imageUrl: comment.authorAvatarUrl,
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                  borderRadius: AppBorders.full,
                ),
              ),
              SizedBox(width: AppSpacing.sm.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(AppSpacing.sm.r),
                      decoration: BoxDecoration(
                        color: cs.surface,
                        border: Border.all(color: cs.outlineVariant),
                        borderRadius: BorderRadius.only(
                          topRight: AppBorders.sm.topRight,
                          bottomRight: AppBorders.sm.bottomRight,
                          bottomLeft: AppBorders.sm.bottomLeft,
                        ),
                      ),
                      child: Text(
                        comment.text,
                        style: tt.bodyMedium?.copyWith(color: cs.onSurface),
                      ),
                    ),
                    SizedBox(height: AppSpacing.xs.h),
                    Row(
                      children: [
                        Text(
                          comment.authorName,
                          style: tt.labelSmall?.copyWith(
                            color: comment.isHost
                                ? const Color(0xFF2E7D32)
                                : cs.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (comment.isHost) ...[
                          SizedBox(width: AppSpacing.xxs.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.xxs.w,
                              vertical: 1.h,
                            ),
                            decoration: const BoxDecoration(
                              color: Color(0xFFE8F5E9),
                              borderRadius: AppBorders.xs,
                            ),
                            child: Text(
                              'Host',
                              style: tt.labelSmall?.copyWith(
                                color: const Color(0xFF2E7D32),
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                        SizedBox(width: AppSpacing.sm.w),
                        Text(
                          timeText,
                          style: tt.labelSmall?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(width: AppSpacing.sm.w),
                        GestureDetector(
                          onTap: () => onReply(comment.authorName),
                          child: Text(
                            'Reply',
                            style: tt.labelSmall?.copyWith(
                              color: cs.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          ...comment.replies.map(
            (reply) => Padding(
              padding: EdgeInsets.only(
                left: 40.w,
                top: AppSpacing.sm.h,
              ),
              child: _SameProductCommentCard(
                comment: reply,
                onReply: onReply,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Bottom Banner ───────────────────────────────────────────────────────────

class _SameProductBottomBanner extends StatelessWidget {
  final SameProductDeal deal;

  const _SameProductBottomBanner({required this.deal});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    final savings = deal.originalPrice > deal.currentPrice
        ? ((1 - deal.currentPrice / deal.originalPrice) * 100).round()
        : 0;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md.w,
          AppSpacing.md.h,
          AppSpacing.md.w,
          AppSpacing.md.h + MediaQuery.of(context).padding.bottom,
        ),
        decoration: BoxDecoration(
          color: cs.surface,
          border: Border(top: BorderSide(color: cs.outlineVariant)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              offset: const Offset(0, -4),
              blurRadius: 6,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '\$${deal.currentPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      color: cs.primary,
                    ),
                  ),
                  if (deal.originalPrice > deal.currentPrice)
                    Text(
                      '\$${deal.originalPrice.toStringAsFixed(2)}',
                      style: tt.bodyMedium?.copyWith(
                        color: cs.onSurfaceVariant,
                        decoration: TextDecoration.lineThrough,
                        fontSize: 14.sp,
                      ),
                    ),
                  if (savings > 0) ...[
                    SizedBox(height: AppSpacing.xxs.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm.w,
                        vertical: 2.h,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8F5E9),
                        borderRadius: AppBorders.xs,
                      ),
                      child: Text(
                        '$savings% OFF',
                        style: tt.labelSmall?.copyWith(
                          color: const Color(0xFF2E7D32),
                          fontWeight: FontWeight.w700,
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (deal.hasTimer) ...[
                      HugeIcon(
                        icon: HugeIcons.strokeRoundedTime02,
                        size: 14.r,
                        color: cs.error,
                      ),
                      SizedBox(width: AppSpacing.xxs.w),
                      Text(
                        'Ends in ${deal.timerText}',
                        style: tt.labelSmall?.copyWith(color: cs.error),
                      ),
                      SizedBox(width: AppSpacing.sm.w),
                    ],
                    HugeIcon(
                      icon: HugeIcons.strokeRoundedBookmark01,
                      size: 14.r,
                      color: cs.onSurfaceVariant,
                    ),
                    SizedBox(width: AppSpacing.xxs.w),
                    Text(
                      '${deal.qtyCurrent}/${deal.qtyGoal} Qty',
                      style: tt.labelSmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.sm.h),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // TODO: Save deal — saved listings screen not built yet
                      },
                      child: Container(
                        width: 48.r,
                        height: 48.r,
                        decoration: BoxDecoration(
                          border: Border.all(color: cs.outline),
                          borderRadius: AppBorders.sm,
                        ),
                        child: Center(
                          child: HugeIcon(
                            icon: HugeIcons.strokeRoundedBookmark01,
                            size: 22.r,
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm.w),
                    GestureDetector(
                      onTap: () {
                        // TODO: Join deal flow
                      },
                      child: Container(
                        height: 48.r,
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.xl.w,
                        ),
                        decoration: BoxDecoration(
                          color: cs.primary,
                          borderRadius: AppBorders.sm,
                        ),
                        child: Center(
                          child: Text(
                            'Join Campaign',
                            style: tt.labelLarge?.copyWith(
                              color: cs.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Mock Data ───────────────────────────────────────────────────────────────

SameProductDealDetail? _getMockSameProductDetail(String dealId) {
  return SameProductDealDetail(
    deal: const SameProductDeal(
      id: '1',
      name: 'Sony WH-1000XM5 Noise Canceling Headphones - Bulk Order',
      imageUrl: 'https://picsum.photos/seed/sonyxm5/800/600',
      currentPrice: 249,
      originalPrice: 399,
      qtyCurrent: 15,
      qtyGoal: 20,
      confirmedQty: 10,
      holdQty: 5,
      timeRemaining: Duration(hours: 48),
      savingsPercentage: 37,
    ),
    description:
        r'Bulk order for Sony WH-1000XM5 headphones. Latest model with industry-leading noise cancellation. We need to reach the 20+ unit tier to get the best price of $249. Pickup will be at the Student Union Room 204.',
    source: 'https://www.amazon.com/dp/B09XS7JWHH',
    categoryTags: const ['TECH & AUDIO', 'SAME PRODUCT'],
    host: const SameProductDealHostInfo(
      name: 'Alex Chen',
      avatarUrl: 'https://picsum.photos/seed/alexchen/200/200',
      reputationPoints: 1247,
      successCount: 12,
      failCount: 1,
    ),
    deadline: DateTime(2026, 10, 27, 17, 0),
    pickupLocation: 'Student Union',
    pickupDetail: 'Room 204',
    pricingTiers: const [
      SameProductPricingTier(minQty: 10, price: 299, isActive: true),
      SameProductPricingTier(minQty: 1, price: 349, isUnlocked: true),
      SameProductPricingTier(minQty: 20, price: 249),
    ],
    updates: [
      SameProductDealUpdate(
        message: 'Almost hit the cap! Make sure payments are uploaded.',
        timestamp: DateTime.now().subtract(const Duration(hours: 12)),
      ),
      SameProductDealUpdate(
        message:
            'We passed the minimum to proceed! Just waiting to fill remaining spots.',
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ],
    comments: [
      SameProductDealComment(
        id: 'c1',
        authorName: '@alex_m',
        authorAvatarUrl: 'https://picsum.photos/seed/alexm/200/200',
        text: 'Hey, is it possible to pickup from north campus?',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        replies: [
          SameProductDealComment(
            id: 'c1r1',
            authorName: '@alex_chen',
            authorAvatarUrl: 'https://picsum.photos/seed/alexchen/200/200',
            text: 'I can meet halfway if you are free at noon.',
            timestamp: DateTime.now().subtract(const Duration(hours: 1)),
            isHost: true,
          ),
        ],
      ),
    ],
  );
}
