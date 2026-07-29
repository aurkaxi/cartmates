import 'package:cartmates/src/imports/imports.dart';
import 'package:cartmates/src/features/deals/domain/entities/same_product_deal_detail.dart';

class DealProgressCard extends StatelessWidget {
  const DealProgressCard({super.key, required this.dealDetail});

  final SameProductDealDetail dealDetail;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final deal = dealDetail.deal;

    final confirmedWidth = deal.confirmedProgress.clamp(0.0, 1.0);
    final holdWidth = deal.holdProgress.clamp(0.0, 1.0 - confirmedWidth);
    final emptyWidth = (1 - confirmedWidth - holdWidth).clamp(0.0, 1.0);

    return AppCard(
      title: 'Deal Progress',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${deal.qtyCurrent} / ${deal.qtyGoal} Qty',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (deal.hasTimer)
                Text(
                  deal.timerText,
                  style: context.textTheme.labelMedium?.copyWith(
                    color: cs.error,
                  ),
                ),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          Container(
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
          ),
          SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              _LegendItem(
                color: cs.primary,
                label: '${deal.confirmedQty} Confirmed',
              ),
              SizedBox(width: AppSpacing.md),
              _LegendItem(
                color: cs.tertiaryContainer,
                label: '${deal.holdQty} Hold',
              ),
              SizedBox(width: AppSpacing.md),
              _LegendItem(
                color: cs.outlineVariant,
                label: '${deal.qtyGoal - deal.qtyCurrent} Interested',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;

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
        SizedBox(width: AppSpacing.xxs),
        Text(
          label,
          style: context.textTheme.labelSmall?.copyWith(
            color: cs.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
