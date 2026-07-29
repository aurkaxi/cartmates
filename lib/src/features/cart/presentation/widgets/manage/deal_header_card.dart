import 'package:cartmates/src/imports/imports.dart';
import 'package:cartmates/src/features/cart/domain/entities/cart_item.dart';
import 'package:cartmates/src/features/deals/domain/entities/same_product_deal_detail.dart';

class DealHeaderCard extends StatelessWidget {
  const DealHeaderCard({
    super.key,
    required this.item,
    required this.dealDetail,
  });

  final CartItem item;
  final SameProductDealDetail dealDetail;

  @override
  Widget build(BuildContext context) {
    final tt = context.textTheme;
    final deal = dealDetail.deal;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _DealImage(imageUrl: item.imageUrl),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: tt.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    DealStatusChip(
                      status: item.dealStatus,
                      type: StatusType.deal,
                      size: ChipSize.small,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _ProgressSection(
            current: deal.qtyCurrent,
            goal: deal.qtyGoal,
            confirmed: deal.confirmedQty,
            hold: deal.holdQty,
          ),
          SizedBox(height: 8.h),
          _PriceRow(
            currentPrice: deal.currentPrice,
            originalPrice: deal.originalPrice,
            savings: deal.savingsPercentage,
          ),
        ],
      ),
    );
  }
}

class _DealImage extends StatelessWidget {
  const _DealImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;

    return Container(
      width: 56.w,
      height: 56.h,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: cs.outlineVariant, width: 1),
      ),
      child: imageUrl.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: AppCachedImage(
                imageUrl: imageUrl,
                width: 56.w,
                height: 56.h,
                fit: BoxFit.cover,
              ),
            )
          : Center(
              child: Icon(
                Icons.shopping_bag_outlined,
                color: cs.onSurfaceVariant,
                size: 24.sp,
              ),
            ),
    );
  }
}

class _ProgressSection extends StatelessWidget {
  const _ProgressSection({
    required this.current,
    required this.goal,
    required this.confirmed,
    required this.hold,
  });

  final int current;
  final int goal;
  final int confirmed;
  final int hold;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final tt = context.textTheme;
    final progress = goal > 0 ? current / goal : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$current / $goal members',
              style: tt.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${(progress * 100).round()}%',
              style: tt.bodyMedium?.copyWith(
                color: cs.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            minHeight: 6.h,
            backgroundColor: cs.surfaceContainerHigh,
            valueColor: AlwaysStoppedAnimation<Color>(
              progress >= 1.0 ? cs.primary : cs.primary.withValues(alpha: 0.6),
            ),
          ),
        ),
        SizedBox(height: 6.h),
        Row(
          children: [
            _StatusCount(
              label: 'Confirmed',
              count: confirmed,
              color: cs.primary,
            ),
            SizedBox(width: 12.w),
            _StatusCount(
              label: 'Pending',
              count: hold,
              color: cs.tertiary,
            ),
          ],
        ),
      ],
    );
  }
}

class _StatusCount extends StatelessWidget {
  const _StatusCount({
    required this.label,
    required this.count,
    required this.color,
  });

  final String label;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final tt = context.textTheme;

    return Row(
      children: [
        Container(
          width: 8.w,
          height: 8.h,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          '$label ($count)',
          style:
              tt.labelSmall?.copyWith(color: context.colors.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({
    required this.currentPrice,
    required this.originalPrice,
    required this.savings,
  });

  final double currentPrice;
  final double originalPrice;
  final double savings;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final tt = context.textTheme;

    return Row(
      children: [
        Text(
          '\$${currentPrice.toStringAsFixed(0)}',
          style: tt.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: cs.primary,
          ),
        ),
        if (originalPrice > currentPrice) ...[
          SizedBox(width: 6.w),
          Text(
            '\$${originalPrice.toStringAsFixed(0)}',
            style: tt.bodySmall?.copyWith(
              decoration: TextDecoration.lineThrough,
              color: cs.onSurfaceVariant,
            ),
          ),
          SizedBox(width: 6.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: cs.errorContainer,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              '-$savings%',
              style: tt.labelSmall?.copyWith(
                color: cs.onErrorContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
