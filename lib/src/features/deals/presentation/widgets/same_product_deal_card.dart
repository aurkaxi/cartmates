import 'package:cartmates/src/imports/imports.dart';

import '../../domain/entities/deal.dart';

enum DealCardVariant { closingSoon, maximumSaving, suggested }

class SameProductDealCard extends StatelessWidget {
  final SameProductDeal deal;
  final DealCardVariant variant;
  final VoidCallback? onTap;

  const SameProductDealCard({
    super.key,
    required this.deal,
    required this.variant,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final cc = context.appColors;
    final tt = context.theme.textTheme;

    return Container(
      width: 200.w,
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: AppBorders.card,
        border: Border.all(color: cs.outline),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppBorders.card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(cs),
            Padding(
              padding: EdgeInsets.all(12.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (variant == DealCardVariant.closingSoon && deal.hasTimer)
                    _buildTimerBadge(cs, tt, isError: true),
                  if (variant == DealCardVariant.maximumSaving)
                    _buildSavingsBadge(cc, tt),
                  SizedBox(height: AppSpacing.xxs.h),
                  _buildName(tt, cs),
                  SizedBox(height: AppSpacing.xxs.h),
                  _buildPriceRow(cs, tt),
                  if (variant != DealCardVariant.suggested) ...[
                    SizedBox(height: AppSpacing.xs.h),
                    _buildProgressBar(cs),
                  ],
                  if (variant == DealCardVariant.suggested) ...[
                    SizedBox(height: AppSpacing.xxs.h),
                    if (deal.hasTimer) _buildTimerBadge(cs, tt, isError: true),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(ColorScheme cs) {
    return Container(
      height: 112.h,
      width: double.infinity,
      color: cs.surfaceContainerHighest,
      child: AppCachedImage(
        imageUrl: deal.imageUrl,
        width: 240,
        height: 112,
        fit: BoxFit.cover,
        useSkeleton: true,
      ),
    );
  }

  Widget _buildTimerBadge(ColorScheme cs, TextTheme tt,
      {required bool isError}) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.xxs.h),
      child: Row(
        children: [
          HugeIcon(
            icon: HugeIcons.strokeRoundedTime02,
            size: 12.r,
            color: isError ? cs.error : cs.onSurfaceVariant,
          ),
          SizedBox(width: AppSpacing.xxs.w),
          Text(
            deal.timerText,
            style: tt.labelSmall?.copyWith(
              color: isError ? cs.error : cs.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavingsBadge(AppColorsExtension cc, TextTheme tt) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.xxs.h),
      child: Row(
        children: [
          HugeIcon(
            icon: HugeIcons.strokeRoundedPercent,
            size: 12.r,
            color: cc.success,
          ),
          SizedBox(width: AppSpacing.xxs.w),
          Text(
            '${deal.savingsPercentage.round()}% OFF',
            style: tt.labelSmall?.copyWith(
              color: cc.success,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildName(TextTheme tt, ColorScheme cs) {
    return Text(
      deal.name,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: tt.titleMedium?.copyWith(
        color: cs.onSurface,
      ),
    );
  }

  Widget _buildPriceRow(ColorScheme cs, TextTheme tt) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '\$${deal.currentPrice.toStringAsFixed(2)}',
              style: tt.bodyMedium?.copyWith(
                color: cs.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (deal.originalPrice > deal.currentPrice)
              Text(
                '\$${deal.originalPrice.toStringAsFixed(2)}',
                style: tt.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.sm.w,
            vertical: AppSpacing.xxs.h,
          ),
          decoration: BoxDecoration(
            color: cs.surfaceContainerHigh,
            borderRadius: AppBorders.xs,
          ),
          child: Text(
            '${deal.qtyCurrent}/${deal.qtyGoal} Qty',
            style: tt.labelSmall?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(ColorScheme cs) {
    final confirmedWidth = deal.confirmedProgress.clamp(0.0, 1.0);
    final holdWidth = deal.holdProgress.clamp(0.0, 1.0 - confirmedWidth);

    return Column(
      children: [
        ClipRRect(
          borderRadius: AppBorders.full,
          child: SizedBox(
            height: 6.h,
            child: Row(
              children: [
                Expanded(
                  flex: (confirmedWidth * 100).round(),
                  child: Container(color: cs.primary),
                ),
                Expanded(
                  flex: (holdWidth * 100).round(),
                  child: Container(color: cs.tertiaryContainer),
                ),
                Expanded(
                  flex: ((1 - confirmedWidth - holdWidth) * 100)
                      .round()
                      .clamp(0, 100),
                  child: Container(color: cs.surfaceDim),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
