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
    CartItemModel(
      id: 'cart_1',
      dealId: 'deal_1',
      name: 'Organic Avocados',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCKyHZcir68Fsgp5ozPzK8aFn2D6x-lkHa4LzzjFGxOGezjMKKZtPK5CwL1XwriszhUCxds9jJPDGGCoCApGCfn--qHePgL9HngP6dBpesOio1O1V4ZNOTT_SY35ehVuEraTre13bzrnihqVDSuG_j332Zjn7QJOp-2XIVMPLUVUTrbS5EvM7Caz1nPeriJ6DwruSOS5NlS3HBkqWFZheYIAM8MCZq6xz5FGdpQMEYI07Ohzk1_GkZ7f4rzvtm5tYjraCNK1hq2OtY',
      price: 24.99,
      quantity: 2,
      status: DealStatus.confirmed,
      tab: CartTab.passive,
      hostName: 'Sarah Chen',
      hostAvatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuArEc-YnnDj2JoKr3UUcBv_s8CzdlY6Qmg2pPs5n-YEiAZNmpf8liUwDls43Zuvk2mpkFQA_7uwX_rGGUDYApbYgaaGczzqjV54OC2gHeo1tb3DkBq0fZrKbfZ2nWuQPioxP1P6137Fb-W1k7egS4EkJ8wR0QXM2E9nalUwIJK3dFlQDrU6gHaN7sFK9ms3i-zd_eaGyGK95erIuK6qUsCbHEIWjkDqWptEGHaOTNHr8LtkAgNDHFQrOAJUpWELnrLyZdcSqZU7c_A',
      joinedAt: DateTime.now().subtract(const Duration(days: 3)),
      estimatedArrival: DateTime.now().add(const Duration(days: 2)),
      progressCurrent: 18,
      progressGoal: 20,
    ),
    CartItemModel(
      id: 'cart_2',
      dealId: 'deal_2',
      name: 'Premium Paper Towels',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuArEc-YnnDj2JoKr3UUcBv_s8CzdlY6Qmg2pPs5n-YEiAZNmpf8liUwDls43Zuvk2mpkFQA_7uwX_rGGUDYApbYgaaGczzqjV54OC2gHeo1tb3DkBq0fZrKbfZ2nWuQPioxP1P6137Fb-W1k7egS4EkJ8wR0QXM2E9nalUwIJK3dFlQDrU6gHaN7sFK9ms3i-zd_eaGyGK95erIuK6qUsCbHEIWjkDqWptEGHaOTNHr8LtkAgNDHFQrOAJUpWELnrLyZdcSqZU7c_A',
      price: 45,
      quantity: 1,
      status: DealStatus.interested,
      tab: CartTab.passive,
      hostName: 'Mike Johnson',
      hostAvatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuArEc-YnnDj2JoKr3UUcBv_s8CzdlY6Qmg2pPs5n-YEiAZNmpf8liUwDls43Zuvk2mpkFQA_7uwX_rGGUDYApbYgaaGczzqjV54OC2gHeo1tb3DkBq0fZrKbfZ2nWuQPioxP1P6137Fb-W1k7egS4EkJ8wR0QXM2E9nalUwIJK3dFlQDrU6gHaN7sFK9ms3i-zd_eaGyGK95erIuK6qUsCbHEIWjkDqWptEGHaOTNHr8LtkAgNDHFQrOAJUpWELnrLyZdcSqZU7c_A',
      joinedAt: DateTime.now().subtract(const Duration(days: 1)),
      progressCurrent: 25,
      progressGoal: 32,
    ),
    CartItemModel(
      id: 'cart_3',
      dealId: 'deal_3',
      name: 'Artisan Coffee Beans',
      imageUrl: '',
      price: 32.50,
      quantity: 3,
      status: DealStatus.hold,
      tab: CartTab.passive,
      hostName: 'Emma Wilson',
      joinedAt: DateTime.now().subtract(const Duration(hours: 12)),
      progressCurrent: 8,
      progressGoal: 10,
    ),
    CartItemModel(
      id: 'cart_4',
      dealId: 'deal_4',
      name: 'Storage Bins Set',
      imageUrl: '',
      price: 28.99,
      quantity: 1,
      status: DealStatus.completed,
      tab: CartTab.passive,
      hostName: 'David Park',
      joinedAt: DateTime.now().subtract(const Duration(days: 7)),
      estimatedArrival: DateTime.now().subtract(const Duration(days: 1)),
      progressCurrent: 10,
      progressGoal: 10,
    ),
  ];

  static final List<CartItem> _mockActiveItems = [
    CartItemModel(
      id: 'cart_5',
      dealId: 'deal_5',
      name: 'IKEA Dorm Run',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCKyHZcir68Fsgp5ozPzK8aFn2D6x-lkHa4LzzjFGxOGezjMKKZtPK5CwL1XwriszhUCxds9jJPDGGCoCApGCfn--qHePgL9HngP6dBpesOio1O1V4ZNOTT_SY35ehVuEraTre13bzrnihqVDSuG_j332Zjn7QJOp-2XIVMPLUVUTrbS5EvM7Caz1nPeriJ6DwruSOS5NlS3HBkqWFZheYIAM8MCZq6xz5FGdpQMEYI07Ohzk1_GkZ7f4rzvtm5tYjraCNK1hq2OtY',
      price: 120,
      quantity: 1,
      status: DealStatus.recruiting,
      tab: CartTab.active,
      hostName: 'You',
      joinedAt: DateTime.now().subtract(const Duration(days: 2)),
      progressCurrent: 8,
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
