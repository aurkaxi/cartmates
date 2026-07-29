import 'package:cartmates/src/imports/imports.dart';
import 'package:cartmates/src/features/cart/domain/entities/cart_item.dart';
import 'package:cartmates/src/features/cart/domain/entities/deal_status.dart';
import 'package:cartmates/src/features/cart/presentation/providers/cart_provider.dart';
import 'package:cartmates/src/features/deals/domain/entities/same_product_deal_detail.dart';
import 'package:cartmates/src/features/deals/domain/entities/deal.dart';

final manageOrderItemProvider =
    FutureProvider.family<CartItem?, String>((ref, dealId) async {
  final getCartItems = ref.watch(getCartItemsProvider);
  final result = await getCartItems(tab: CartTab.active);
  return result.fold(
    (failure) => null,
    (items) => items.where((item) => item.dealId == dealId).firstOrNull,
  );
});

final manageActiveTabProvider =
    StateProvider.family<ParticipantStatus?, String>((ref, dealId) => null);

SameProductDealDetail getMockManageDealDetail(String dealId) {
  return SameProductDealDetail(
    deal: SameProductDeal(
      id: dealId,
      name: 'IKEA Dorm Run',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCKyHZcir68Fsgp5ozPzK8aFn2D6x-lkHa4LzzjFGxOGezjMKKZtPK5CwL1XwriszhUCxds9jJPDGGCoCApGCfn--qHePgL9HngP6dBpesOio1O1V4ZNOTT_SY35ehVuEraTre13bzrnihqVDSuG_j332Zjn7QJOp-2XIVMPLUVUTrbS5EvM7Caz1nPeriJ6DwruSOS5NlS3HBkqWFZheYIAM8MCZq6xz5FGdpQMEYI07Ohzk1_GkZ7f4rzvtm5tYjraCNK1hq2OtY',
      currentPrice: 120,
      originalPrice: 180,
      qtyCurrent: 8,
      qtyGoal: 10,
      confirmedQty: 6,
      holdQty: 2,
      timeRemaining: const Duration(hours: 48),
      savingsPercentage: 33,
    ),
    description:
        'Bulk IKEA dorm room essentials. Bedding, storage, desk organizer.',
    source: 'https://www.ikea.com',
    categoryTags: const ['DORM', 'BULK'],
    host: const SameProductDealHostInfo(
      userId: '1',
      name: 'You (Host)',
      avatarUrl: '',
      reputationPoints: 500,
      successCount: 8,
      failCount: 0,
    ),
    deadline: DateTime.now().add(const Duration(hours: 48)),
    pickupLocation: 'Student Union Building',
    pickupDetail: 'Floor 2, Room 214',
    pricingTiers: const [],
    updates: [
      SameProductDealUpdate(
        message:
            'Hey everyone! We are almost at our goal. Please submit payment proofs soon.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    ],
  );
}

List<CartItemMember> getMockMembers(String dealId) {
  return [
    CartItemMember(
      userId: 'u1',
      name: 'Alice Johnson',
      avatarUrl: '',
      status: ParticipantStatus.confirmed,
      quantity: 2,
      totalPaid: 240,
      paymentProofUrl: 'https://example.com/proof_alice.png',
      joinedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    CartItemMember(
      userId: 'u2',
      name: 'Bob Smith',
      avatarUrl: '',
      status: ParticipantStatus.confirmed,
      quantity: 1,
      totalPaid: 120,
      paymentProofUrl: 'https://example.com/proof_bob.png',
      joinedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    CartItemMember(
      userId: 'u3',
      name: 'Charlie Brown',
      avatarUrl: '',
      status: ParticipantStatus.hold,
      quantity: 1,
      totalPaid: 120,
      paymentProofUrl: 'https://example.com/proof_charlie.png',
      joinedAt: DateTime.now().subtract(const Duration(hours: 20)),
    ),
    CartItemMember(
      userId: 'u4',
      name: 'Diana Prince',
      avatarUrl: '',
      status: ParticipantStatus.hold,
      quantity: 2,
      totalPaid: 240,
      paymentProofUrl: 'https://example.com/proof_diana.png',
      joinedAt: DateTime.now().subtract(const Duration(hours: 12)),
    ),
    CartItemMember(
      userId: 'u5',
      name: 'Eve Davis',
      avatarUrl: '',
      status: ParticipantStatus.denied,
      quantity: 1,
      totalPaid: 0,
      joinedAt: DateTime.now().subtract(const Duration(hours: 8)),
    ),
    CartItemMember(
      userId: 'u6',
      name: 'Frank Wilson',
      avatarUrl: '',
      status: ParticipantStatus.disputed,
      quantity: 1,
      totalPaid: 120,
      paymentProofUrl: 'https://example.com/proof_frank.png',
      joinedAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
  ];
}

class CartItemMember {
  final String userId;
  final String name;
  final String avatarUrl;
  final ParticipantStatus status;
  final int quantity;
  final double totalPaid;
  final String? paymentProofUrl;
  final DateTime joinedAt;

  const CartItemMember({
    required this.userId,
    required this.name,
    required this.avatarUrl,
    required this.status,
    required this.quantity,
    required this.totalPaid,
    this.paymentProofUrl,
    required this.joinedAt,
  });
}
