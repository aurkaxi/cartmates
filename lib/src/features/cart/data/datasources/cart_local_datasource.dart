import 'package:cartmates/src/features/cart/data/models/cart_item_model.dart';
import 'package:cartmates/src/features/cart/domain/entities/cart_item.dart';
import 'package:cartmates/src/features/cart/domain/entities/deal_status.dart';
import 'package:cartmates/src/utils/typedefs.dart';
import 'package:fpdart/fpdart.dart';

abstract class CartLocalDataSource {
  FutureEither<List<CartItem>> getCartItems({required CartTab tab});
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  static final List<CartItem> _mockPassiveItems = [
    // 1. Passive - recruiting, hold (user submitted proof, awaiting host)
    CartItemModel(
      id: 'cart_1',
      dealId: 'deal_1',
      name: 'Organic Avocados',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCKyHZcir68Fsgp5ozPzK8aFn2D6x-lkHa4LzzjFGxOGezjMKKZtPK5CwL1XwriszhUCxds9jJPDGGCoCApGCfn--qHePgL9HngP6dBpesOio1O1V4ZNOTT_SY35ehVuEraTre13bzrnihqVDSuG_j332Zjn7QJOp-2XIVMPLUVUTrbS5EvM7Caz1nPeriJ6DwruSOS5NlS3HBkqWFZheYIAM8MCZq6xz5FGdpQMEYI07Ohzk1_GkZ7f4rzvtm5tYjraCNK1hq2OtY',
      price: 24.99,
      quantity: 2,
      participantStatus: ParticipantStatus.hold,
      dealStatus: DealStatus.recruiting,
      tab: CartTab.passive,
      hostName: 'Sarah Chen',
      hostAvatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuArEc-YnnDj2JoKr3UUcBv_s8CzdlY6Qmg2pPs5n-YEiAZNmpf8liUwDls43Zuvk2mpkFQA_7uwX_rGGUDYApbYgaaGczzqjV54OC2gHeo1tb3DkBq0fZrKbfZ2nWuQPioxP1P6137Fb-W1k7egS4EkJ8wR0QXM2E9nalUwIJK3dFlQDrU6gHaN7sFK9ms3i-zd_eaGyGK95erIuK6qUsCbHEIWjkDqWptEGHaOTNHr8LtkAgNDHFQrOAJUpWELnrLyZdcSqZU7c_A',
      joinedAt: DateTime.now().subtract(const Duration(days: 3)),
      estimatedArrival: DateTime.now().add(const Duration(days: 2)),
      progressCurrent: 18,
      progressGoal: 20,
    ),
    // 2. Passive - recruiting, confirmed (host approved, deal still recruiting)
    CartItemModel(
      id: 'cart_2',
      dealId: 'deal_2',
      name: 'Premium Paper Towels',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuArEc-YnnDj2JoKr3UUcBv_s8CzdlY6Qmg2pPs5n-YEiAZNmpf8liUwDls43Zuvk2mpkFQA_7uwX_rGGUDYApbYgaaGczzqjV54OC2gHeo1tb3DkBq0fZrKbfZ2nWuQPioxP1P6137Fb-W1k7egS4EkJ8wR0QXM2E9nalUwIJK3dFlQDrU6gHaN7sFK9ms3i-zd_eaGyGK95erIuK6qUsCbHEIWjkDqWptEGHaOTNHr8LtkAgNDHFQrOAJUpWELnrLyZdcSqZU7c_A',
      price: 45,
      quantity: 1,
      participantStatus: ParticipantStatus.confirmed,
      dealStatus: DealStatus.recruiting,
      tab: CartTab.passive,
      hostName: 'Mike Johnson',
      hostAvatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuArEc-YnnDj2JoKr3UUcBv_s8CzdlY6Qmg2pPs5n-YEiAZNmpf8liUwDls43Zuvk2mpkFQA_7uwX_rGGUDYApbYgaaGczzqjV54OC2gHeo1tb3DkBq0fZrKbfZ2nWuQPioxP1P6137Fb-W1k7egS4EkJ8wR0QXM2E9nalUwIJK3dFlQDrU6gHaN7sFK9ms3i-zd_eaGyGK95erIuK6qUsCbHEIWjkDqWptEGHaOTNHr8LtkAgNDHFQrOAJUpWELnrLyZdcSqZU7c_A',
      joinedAt: DateTime.now().subtract(const Duration(days: 1)),
      progressCurrent: 25,
      progressGoal: 32,
    ),
    // 3. Passive - recruiting, denied (host rejected, user can dispute)
    CartItemModel(
      id: 'cart_3',
      dealId: 'deal_3',
      name: 'Artisan Coffee Beans',
      imageUrl: '',
      price: 32.50,
      quantity: 3,
      participantStatus: ParticipantStatus.denied,
      dealStatus: DealStatus.recruiting,
      tab: CartTab.passive,
      hostName: 'Emma Wilson',
      joinedAt: DateTime.now().subtract(const Duration(hours: 12)),
      progressCurrent: 8,
      progressGoal: 10,
    ),
    // 4. Passive - expired, confirmed (time up, host deciding cancel/order)
    CartItemModel(
      id: 'cart_4',
      dealId: 'deal_4',
      name: 'Storage Bins Set',
      imageUrl: '',
      price: 28.99,
      quantity: 1,
      participantStatus: ParticipantStatus.confirmed,
      dealStatus: DealStatus.expired,
      tab: CartTab.passive,
      hostName: 'David Park',
      joinedAt: DateTime.now().subtract(const Duration(days: 7)),
      estimatedArrival: DateTime.now().subtract(const Duration(days: 1)),
      progressCurrent: 10,
      progressGoal: 10,
    ),
    // 5. Passive - ordered, confirmed (host ordered, tracking available)
    CartItemModel(
      id: 'cart_5',
      dealId: 'deal_5',
      name: 'IKEA Dorm Run',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCKyHZcir68Fsgp5ozPzK8aFn2D6x-lkHa4LzzjFGxOGezjMKKZtPK5CwL1XwriszhUCxds9jJPDGGCoCApGCfn--qHePgL9HngP6dBpesOio1O1V4ZNOTT_SY35ehVuEraTre13bzrnihqVDSuG_j332Zjn7QJOp-2XIVMPLUVUTrbS5EvM7Caz1nPeriJ6DwruSOS5NlS3HBkqWFZheYIAM8MCZq6xz5FGdpQMEYI07Ohzk1_GkZ7f4rzvtm5tYjraCNK1hq2OtY',
      price: 120,
      quantity: 1,
      participantStatus: ParticipantStatus.confirmed,
      dealStatus: DealStatus.ordered,
      tab: CartTab.passive,
      hostName: 'You',
      joinedAt: DateTime.now().subtract(const Duration(days: 2)),
      progressCurrent: 8,
      progressGoal: 10,
      trackingNumber: 'TRK123456789',
      trackingUrl: 'https://track.example.com/TRK123456789',
    ),
    // 6. Passive - arrived, not received (goods at host, pending pickup)
    CartItemModel(
      id: 'cart_6',
      dealId: 'deal_6',
      name: 'Bulk Laundry Detergent',
      imageUrl: '',
      price: 35,
      quantity: 2,
      participantStatus: ParticipantStatus.arrived,
      dealStatus: DealStatus.arrived,
      tab: CartTab.passive,
      hostName: 'Lisa Chen',
      joinedAt: DateTime.now().subtract(const Duration(days: 10)),
      received: false,
    ),
    // 7. Passive - arrived, received (user picked up)
    CartItemModel(
      id: 'cart_7',
      dealId: 'deal_7',
      name: 'Campus Snack Pack',
      imageUrl: '',
      price: 18.5,
      quantity: 1,
      participantStatus: ParticipantStatus.completed,
      dealStatus: DealStatus.arrived,
      tab: CartTab.passive,
      hostName: 'Alex Rivera',
      joinedAt: DateTime.now().subtract(const Duration(days: 14)),
      received: true,
    ),
    // 8. Passive - completed (all done)
    CartItemModel(
      id: 'cart_8',
      dealId: 'deal_8',
      name: 'Group Textbook Order',
      imageUrl: '',
      price: 85,
      quantity: 1,
      participantStatus: ParticipantStatus.completed,
      dealStatus: DealStatus.completed,
      tab: CartTab.passive,
      hostName: 'Jordan Kim',
      joinedAt: DateTime.now().subtract(const Duration(days: 30)),
      received: true,
    ),
    // 9. Passive - recruiting, disputed (admin dispute in progress)
    CartItemModel(
      id: 'cart_9',
      dealId: 'deal_9',
      name: 'Wireless Earbuds Bulk',
      imageUrl: '',
      price: 42,
      quantity: 1,
      participantStatus: ParticipantStatus.denied,
      dealStatus: DealStatus.recruiting,
      tab: CartTab.passive,
      hostName: 'Taylor Swift',
      joinedAt: DateTime.now().subtract(const Duration(days: 5)),
      progressCurrent: 12,
      progressGoal: 15,
    ),
  ];

  static final List<CartItem> _mockActiveItems = [
    // 10. Active - recruiting (host waiting for members)
    CartItemModel(
      id: 'cart_10',
      dealId: 'deal_10',
      name: 'IKEA Dorm Run',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCKyHZcir68Fsgp5ozPzK8aFn2D6x-lkHa4LzzjFGxOGezjMKKZtPK5CwL1XwriszhUCxds9jJPDGGCoCApGCfn--qHePgL9HngP6dBpesOio1O1V4ZNOTT_SY35ehVuEraTre13bzrnihqVDSuG_j332Zjn7QJOp-2XIVMPLUVUTrbS5EvM7Caz1nPeriJ6DwruSOS5NlS3HBkqWFZheYIAM8MCZq6xz5FGdpQMEYI07Ohzk1_GkZ7f4rzvtm5tYjraCNK1hq2OtY',
      price: 120,
      quantity: 1,
      participantStatus: ParticipantStatus.confirmed,
      dealStatus: DealStatus.recruiting,
      tab: CartTab.active,
      hostName: 'You',
      joinedAt: DateTime.now().subtract(const Duration(days: 2)),
      progressCurrent: 8,
      progressGoal: 10,
    ),
    // 11. Active - ready (host can place order now)
    CartItemModel(
      id: 'cart_11',
      dealId: 'deal_11',
      name: 'Bulk Protein Powder',
      imageUrl: '',
      price: 55,
      quantity: 1,
      participantStatus: ParticipantStatus.confirmed,
      dealStatus: DealStatus.ready,
      tab: CartTab.active,
      hostName: 'You',
      joinedAt: DateTime.now().subtract(const Duration(days: 5)),
      progressCurrent: 20,
      progressGoal: 20,
    ),
    // 12. Active - expired (host: cancel or order with less)
    CartItemModel(
      id: 'cart_12',
      dealId: 'deal_12',
      name: 'Campus Coffee Run',
      imageUrl: '',
      price: 22,
      quantity: 1,
      participantStatus: ParticipantStatus.confirmed,
      dealStatus: DealStatus.expired,
      tab: CartTab.active,
      hostName: 'You',
      joinedAt: DateTime.now().subtract(const Duration(days: 10)),
      progressCurrent: 12,
      progressGoal: 15,
    ),
    // 13. Active - ordered (host: add tracking link)
    CartItemModel(
      id: 'cart_13',
      dealId: 'deal_13',
      name: 'Dorm Essentials Kit',
      imageUrl: '',
      price: 89,
      quantity: 1,
      participantStatus: ParticipantStatus.confirmed,
      dealStatus: DealStatus.ordered,
      tab: CartTab.active,
      hostName: 'You',
      joinedAt: DateTime.now().subtract(const Duration(days: 3)),
      trackingNumber: 'TRK987654321',
      trackingUrl: 'https://track.example.com/TRK987654321',
    ),
    // 14. Active - arrived (host: distribute, mark received)
    CartItemModel(
      id: 'cart_14',
      dealId: 'deal_14',
      name: 'Shared Fridge Stock',
      imageUrl: '',
      price: 45,
      quantity: 1,
      participantStatus: ParticipantStatus.confirmed,
      dealStatus: DealStatus.arrived,
      tab: CartTab.active,
      hostName: 'You',
      joinedAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
    // 15. Active - completed (all distributed)
    CartItemModel(
      id: 'cart_15',
      dealId: 'deal_15',
      name: 'Semester Book Bundle',
      imageUrl: '',
      price: 120,
      quantity: 1,
      participantStatus: ParticipantStatus.completed,
      dealStatus: DealStatus.completed,
      tab: CartTab.active,
      hostName: 'You',
      joinedAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    // 16. Active - cancelled
    CartItemModel(
      id: 'cart_16',
      dealId: 'deal_16',
      name: 'Cancelled Group Order',
      imageUrl: '',
      price: 30,
      quantity: 1,
      participantStatus: ParticipantStatus.confirmed,
      dealStatus: DealStatus.cancelled,
      tab: CartTab.active,
      hostName: 'You',
      joinedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    // 17. Active - disputed (admin dispute)
    CartItemModel(
      id: 'cart_17',
      dealId: 'deal_17',
      name: 'Disputed Electronics Order',
      imageUrl: '',
      price: 200,
      quantity: 1,
      participantStatus: ParticipantStatus.confirmed,
      dealStatus: DealStatus.recruiting,
      tab: CartTab.active,
      hostName: 'You',
      joinedAt: DateTime.now().subtract(const Duration(days: 1)),
      progressCurrent: 5,
      progressGoal: 10,
    ),
  ];

  @override
  FutureEither<List<CartItem>> getCartItems({required CartTab tab}) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final items = tab == CartTab.passive ? _mockPassiveItems : _mockActiveItems;
    return right(items);
  }
}
