import 'package:cartmates/src/features/cart/presentation/providers/cart_provider.dart';
import 'package:cartmates/src/features/cart/presentation/widgets/cart_item_tile.dart';
import 'package:cartmates/src/features/cart/presentation/widgets/cart_status_filter.dart';
import 'package:cartmates/src/features/cart/presentation/widgets/cart_tab_bar.dart';
import 'package:cartmates/src/imports/imports.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CartTabBar(),
            const CartStatusFilter(),
            Expanded(
              child: _CartList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(filteredCartItemsProvider);

    if (items.isEmpty) {
      return const AppEmptyState(
        icon: HugeIcons.strokeRoundedShoppingBag01,
        title: 'No deals yet',
        subtitle: 'Join or host deals to see them here',
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      itemCount: items.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final item = items[index];
        return CartItemTile(item: item);
      },
    );
  }
}
