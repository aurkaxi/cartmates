import 'package:cartmates/src/features/cart/domain/entities/deal_status.dart';
import 'package:cartmates/src/features/cart/presentation/providers/cart_provider.dart';
import 'package:cartmates/src/imports/imports.dart';

class CartStatusFilter extends ConsumerWidget {
  const CartStatusFilter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = context.colors;
    final selectedFilter = ref.watch(cartStatusFilterProvider);
    final filters = [
      null,
      DealStatus.recruiting,
      DealStatus.interested,
      DealStatus.hold,
      DealStatus.confirmed,
      DealStatus.ordered,
      DealStatus.arrived,
      DealStatus.completed,
    ];

    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter;
          final label = filter?.label ?? 'All';

          return GestureDetector(
            onTap: () =>
                ref.read(cartStatusFilterProvider.notifier).state = filter,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isSelected ? cs.primary : cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isSelected ? cs.primary : cs.outlineVariant,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Center(
                child: Text(
                  label,
                  style: context.textTheme.labelSmall?.copyWith(
                    color: isSelected ? cs.onPrimary : cs.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
