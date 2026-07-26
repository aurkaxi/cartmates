import 'package:cartmates/src/features/cart/domain/entities/deal_status.dart';
import 'package:cartmates/src/features/cart/presentation/providers/cart_provider.dart';
import 'package:cartmates/src/imports/imports.dart';

class CartTabBar extends ConsumerWidget {
  const CartTabBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = context.colors;
    final selectedTab = ref.watch(cartTabProvider);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Container(
        height: 40.h,
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: cs.outlineVariant, width: 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: _TabButton(
                label: CartTab.passive.label,
                isSelected: selectedTab == CartTab.passive,
                onTap: () =>
                    ref.read(cartTabProvider.notifier).state = CartTab.passive,
              ),
            ),
            Expanded(
              child: _TabButton(
                label: CartTab.active.label,
                isSelected: selectedTab == CartTab.active,
                onTap: () =>
                    ref.read(cartTabProvider.notifier).state = CartTab.active,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final tt = context.textTheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? cs.secondaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          label,
          style: tt.labelLarge?.copyWith(
            color: isSelected ? cs.onSecondaryContainer : cs.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
