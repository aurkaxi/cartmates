import '../../domain/entities/create_deal_draft.dart';
import '../../../deals/domain/entities/same_product_deal_detail.dart';
import '../../../deals/domain/entities/deal.dart';

class CreateDealMockDatasource {
  CreateDealMockDatasource._();
  static final CreateDealMockDatasource instance = CreateDealMockDatasource._();

  static const String _mockImageUrl =
      'https://picsum.photos/seed/newproduct/800/600';

  Future<SameProductDealDetail> createDeal(CreateDealDraft draft) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));

    final dealId = DateTime.now().millisecondsSinceEpoch.toString();

    final sortedTiers = List<CreateDealTierDraft>.from(draft.pricingTiers)
      ..sort((a, b) => a.minQty.compareTo(b.minQty));

    final lowestPrice = sortedTiers.last.price;

    final savings = draft.originalPrice > 0
        ? ((1 - lowestPrice / draft.originalPrice) * 100).round()
        : 0;

    final remaining = draft.deadline.difference(DateTime.now());
    final timeRemaining =
        remaining.isNegative ? const Duration(hours: 1) : remaining;

    final deal = SameProductDeal(
      id: dealId,
      name: draft.name,
      imageUrl: draft.imageFile != null ? _mockImageUrl : _mockImageUrl,
      currentPrice: lowestPrice,
      originalPrice: draft.originalPrice,
      qtyCurrent: 0,
      qtyGoal: draft.qtyGoal,
      confirmedQty: 0,
      holdQty: 0,
      timeRemaining: timeRemaining,
      savingsPercentage: savings.toDouble(),
    );

    final pricingTiers = sortedTiers.asMap().entries.map((entry) {
      final tier = entry.value;
      return SameProductPricingTier(
        minQty: tier.minQty,
        price: tier.price,
        isUnlocked: tier.minQty == 1,
        isActive: entry.key == 0,
      );
    }).toList();

    return SameProductDealDetail(
      deal: deal,
      description: draft.description,
      source: draft.sourceUrl,
      categoryTags:
          draft.categories.isNotEmpty ? draft.categories : ['GENERAL'],
      host: const SameProductDealHostInfo(
        userId: 'self',
        name: 'You',
        avatarUrl: 'https://picsum.photos/seed/currentuser/200/200',
        reputationPoints: 500,
        successCount: 5,
        failCount: 0,
      ),
      deadline: draft.deadline,
      pickupLocation: draft.pickupLocation,
      pickupDetail: '',
      pricingTiers: pricingTiers,
    );
  }
}
