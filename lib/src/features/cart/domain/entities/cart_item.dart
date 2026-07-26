import 'package:cartmates/src/features/cart/domain/entities/deal_status.dart';
import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final String id;
  final String dealId;
  final String name;
  final String imageUrl;
  final double price;
  final int quantity;
  final ParticipantStatus participantStatus;
  final DealStatus dealStatus;
  final CartTab tab;
  final String? hostName;
  final String? hostAvatarUrl;
  final DateTime? joinedAt;
  final DateTime? estimatedArrival;
  final int? progressCurrent;
  final int? progressGoal;
  final String? trackingNumber;
  final String? trackingUrl;
  final bool received;

  const CartItem({
    required this.id,
    required this.dealId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.participantStatus,
    required this.dealStatus,
    required this.tab,
    this.hostName,
    this.hostAvatarUrl,
    this.joinedAt,
    this.estimatedArrival,
    this.progressCurrent,
    this.progressGoal,
    this.trackingNumber,
    this.trackingUrl,
    this.received = false,
  });

  String get quantityText => 'Qty: $quantity';

  String get progressText {
    if (progressCurrent != null && progressGoal != null) {
      return '$progressCurrent/$progressGoal';
    }
    return '';
  }

  @override
  List<Object?> get props => [
        id,
        dealId,
        name,
        imageUrl,
        price,
        quantity,
        participantStatus,
        dealStatus,
        tab,
        hostName,
        hostAvatarUrl,
        joinedAt,
        estimatedArrival,
        progressCurrent,
        progressGoal,
        trackingNumber,
        trackingUrl,
        received,
      ];
}
