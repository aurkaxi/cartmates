import 'package:cartmates/src/features/cart/domain/entities/cart_item.dart';
import 'package:cartmates/src/features/cart/domain/entities/deal_status.dart';

class CartItemModel extends CartItem {
  const CartItemModel({
    required super.id,
    required super.dealId,
    required super.name,
    required super.imageUrl,
    required super.price,
    required super.quantity,
    required super.status,
    required super.tab,
    super.hostName,
    super.hostAvatarUrl,
    super.joinedAt,
    super.estimatedArrival,
    super.progressCurrent,
    super.progressGoal,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] as String,
      dealId: json['dealId'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
      status: DealStatus.fromString(json['status'] as String),
      tab: CartTab.values.firstWhere(
        (e) => e.name == (json['tab'] as String),
        orElse: () => CartTab.passive,
      ),
      hostName: json['hostName'] as String?,
      hostAvatarUrl: json['hostAvatarUrl'] as String?,
      joinedAt: json['joinedAt'] != null
          ? DateTime.parse(json['joinedAt'] as String)
          : null,
      estimatedArrival: json['estimatedArrival'] != null
          ? DateTime.parse(json['estimatedArrival'] as String)
          : null,
      progressCurrent: json['progressCurrent'] as int?,
      progressGoal: json['progressGoal'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dealId': dealId,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'quantity': quantity,
      'status': status.name,
      'tab': tab.name,
      'hostName': hostName,
      'hostAvatarUrl': hostAvatarUrl,
      'joinedAt': joinedAt?.toIso8601String(),
      'estimatedArrival': estimatedArrival?.toIso8601String(),
      'progressCurrent': progressCurrent,
      'progressGoal': progressGoal,
    };
  }
}
