import 'package:cartmates/src/imports/imports.dart';
import 'package:cartmates/src/features/deals/domain/entities/deal.dart';
import '../providers/saved_deals_provider.dart';

class SavedDealTile extends ConsumerWidget {
  const SavedDealTile({super.key, required this.deal});

  final SameProductDeal deal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Dismissible(
      key: ValueKey(deal.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) async {
        final repo = ref.read(savedRepositoryProvider);
        await repo.toggleSave(deal.id);
        ref.invalidate(savedDealsProvider);
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.w),
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: cs.error,
          borderRadius: AppBorders.md,
        ),
        child: HugeIcon(
          icon: HugeIcons.strokeRoundedDelete02,
          size: 22.r,
          color: cs.onError,
        ),
      ),
      child: InkWell(
        onTap: () => context.push(AppRoutes.savedDetailPath(deal.id)),
        borderRadius: AppBorders.md,
        child: Container(
          height: 80.h,
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: AppBorders.md,
            border: Border.all(color: cs.outlineVariant),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Row(
            children: [
              _buildImage(cs),
              SizedBox(width: 12.w),
              Expanded(child: _buildContent(tt, cs)),
              _buildTrailing(tt, cs),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(ColorScheme cs) {
    return Container(
      width: 56.w,
      height: 56.h,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: AppBorders.sm,
        border: Border.all(color: cs.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: AppCachedImage(
        imageUrl: deal.imageUrl,
        width: 56.w,
        height: 56.h,
        fit: BoxFit.cover,
        useSkeleton: true,
      ),
    );
  }

  Widget _buildContent(TextTheme tt, ColorScheme cs) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          deal.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: tt.titleSmall?.copyWith(
            color: cs.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            Text(
              '\$${deal.currentPrice.toStringAsFixed(2)}',
              style: tt.bodySmall?.copyWith(
                color: cs.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (deal.originalPrice > deal.currentPrice) ...[
              SizedBox(width: 6.w),
              Text(
                '\$${deal.originalPrice.toStringAsFixed(2)}',
                style: tt.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
            if (deal.savingsPercentage > 0) ...[
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: AppBorders.xs,
                ),
                child: Text(
                  '${deal.savingsPercentage.round()}% OFF',
                  style: tt.labelSmall?.copyWith(
                    color: cs.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            if (deal.hasTimer) ...[
              HugeIcon(
                icon: HugeIcons.strokeRoundedTime02,
                size: 12.r,
                color: cs.onSurfaceVariant,
              ),
              SizedBox(width: 4.w),
              Text(
                deal.timerText,
                style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant),
              ),
              SizedBox(width: 12.w),
            ],
            Text(
              '${deal.qtyCurrent}/${deal.qtyGoal} Qty',
              style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTrailing(TextTheme tt, ColorScheme cs) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedArrowRight01,
      size: 18.r,
      color: cs.onSurfaceVariant,
    );
  }
}
