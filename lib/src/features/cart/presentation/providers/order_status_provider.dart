import 'package:cartmates/src/imports/imports.dart';
import 'package:cartmates/src/features/cart/domain/entities/cart_item.dart';
import 'package:cartmates/src/features/cart/domain/entities/deal_status.dart';
import 'package:cartmates/src/features/cart/presentation/providers/cart_provider.dart';
import 'package:cartmates/src/features/deals/domain/entities/deal.dart';
import 'package:cartmates/src/features/deals/domain/entities/same_product_deal_detail.dart';

final orderStatusItemProvider =
    FutureProvider.family<CartItem?, String>((ref, dealId) async {
  final getCartItems = ref.watch(getCartItemsProvider);
  final result = await getCartItems(tab: CartTab.passive);
  return result.fold(
    (failure) => null,
    (items) => items.where((item) => item.dealId == dealId).firstOrNull,
  );
});

SameProductDealDetail getMockDealDetail(String dealId) {
  return SameProductDealDetail(
    deal: SameProductDeal(
      id: dealId,
      name: 'Costco Bulk Toilet Paper',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCKyHZcir68Fsgp5ozPzK8aFn2D6x-lkHa4LzzjFGxOGezjMKKZtPK5CwL1XwriszhUCxds9jJPDGGCoCApGCfn--qHePgL9HngP6dBpesOio1O1V4ZNOTT_SY35ehVuEraTre13bzrnihqVDSuG_j332Zjn7QJOp-2XIVMPLUVUTrbS5EvM7Caz1nPeriJ6DwruSOS5NlS3HBkqWFZheYIAM8MCZq6xz5FGdpQMEYI07Ohzk1_GkZ7f4rzvtm5tYjraCNK1hq2OtY',
      currentPrice: 7,
      originalPrice: 12,
      qtyCurrent: 18,
      qtyGoal: 20,
      confirmedQty: 12,
      holdQty: 6,
      timeRemaining: const Duration(hours: 48),
      savingsPercentage: 39,
    ),
    description:
        'Bulk order for Kirkland Signature Bath Tissue. 30 rolls per pack, 2-ply.',
    source: 'https://www.costco.com',
    categoryTags: const ['HOUSEHOLD', 'SAME PRODUCT'],
    host: const SameProductDealHostInfo(
      userId: '2',
      name: 'Sarah Jenkins',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCixJTgrbzB5Kw0_wDEihiDC-Ya0sMjjkbyjFdLQ3L5DgSrS13zhzlWCTEunxfInHLe_9wKXAO6NY7ZZNgwKDrcVO7VLvXYA1FNNYsfGerMUcwxHJg-fjt4XMNlN2IVOCEOgR7yZAhoWTAVKQ2gC1rdVMlI7-IGHXhCTHm3UojUpQ7t_OdOCgqrHz3zpmZz0CxJZxZy3OrLymYtXYDlKS58dOJhOTA5G6sQUyg9tWPJfAiRG1QdKTg58-dpoFu4xBO8wXlGW7mxnlw',
      reputationPoints: 490,
      successCount: 12,
      failCount: 1,
    ),
    deadline: DateTime.now().add(const Duration(hours: 48)),
    pickupLocation: 'Student Union Building',
    pickupDetail: 'Floor 2, Room 214',
    pricingTiers: const [],
    updates: [
      SameProductDealUpdate(
        message:
            'Hey everyone, I just got the notification that the delivery truck is on campus. I will update again once I have sorted everything in SUB 214.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    ],
  );
}
