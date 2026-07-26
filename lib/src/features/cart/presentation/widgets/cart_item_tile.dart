import 'package:cartmates/src/features/cart/domain/entities/cart_item.dart';
import 'package:cartmates/src/features/cart/domain/entities/deal_status.dart';
import 'package:cartmates/src/imports/imports.dart';

class CartItemTile extends ConsumerWidget {
  const CartItemTile({super.key, required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = context.colors;
    final tt = context.textTheme;

    return InkWell(
      onTap: () => context.push(AppRoutes.cartOrderPath(item.dealId)),
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        height: 72.h,
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: cs.outlineVariant, width: 1),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: [
            _buildLeading(cs),
            SizedBox(width: 16.w),
            Expanded(child: _buildContent(tt, cs)),
            _buildTrailing(cs, tt),
          ],
        ),
      ),
    );
  }

  Widget _buildLeading(ColorScheme cs) {
    return Container(
      width: 40.w,
      height: 40.h,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: cs.outlineVariant, width: 1),
      ),
      child: item.imageUrl.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: AppCachedImage(
                imageUrl: item.imageUrl,
                width: 40.w,
                height: 40.h,
                fit: BoxFit.cover,
              ),
            )
          : Center(
              child: Icon(
                item.tab == CartTab.active
                    ? Icons.shopping_bag_outlined
                    : Icons.local_shipping_outlined,
                color: cs.onSurfaceVariant,
                size: 20.sp,
              ),
            ),
    );
  }

  Widget _buildContent(TextTheme tt, ColorScheme cs) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.name,
          style: tt.titleMedium?.copyWith(
            color: cs.onSurface,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (item.progressCurrent != null && item.progressGoal != null) ...[
          SizedBox(height: 2.h),
          Text(
            '${item.progressCurrent}/${item.progressGoal}',
            style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant),
          ),
        ] else if (item.quantity > 1) ...[
          SizedBox(height: 2.h),
          Text(
            item.quantityText,
            style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant),
          ),
        ],
      ],
    );
  }

  Widget _buildTrailing(ColorScheme cs, TextTheme tt) {
    return DealStatusChip(
      status: item.status,
      size: ChipSize.medium,
    );
  }
}
