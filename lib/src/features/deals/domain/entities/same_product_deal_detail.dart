import 'package:equatable/equatable.dart';

import 'deal.dart';

class SameProductDealHostInfo extends Equatable {
  final String name;
  final String avatarUrl;
  final int reputationPoints;
  final int successCount;
  final int failCount;

  const SameProductDealHostInfo({
    required this.name,
    required this.avatarUrl,
    required this.reputationPoints,
    required this.successCount,
    required this.failCount,
  });

  @override
  List<Object?> get props => [
        name,
        avatarUrl,
        reputationPoints,
        successCount,
        failCount,
      ];
}

class SameProductPricingTier extends Equatable {
  final int minQty;
  final double price;
  final bool isUnlocked;
  final bool isActive;

  const SameProductPricingTier({
    required this.minQty,
    required this.price,
    this.isUnlocked = false,
    this.isActive = false,
  });

  @override
  List<Object?> get props => [minQty, price, isUnlocked, isActive];
}

class SameProductDealUpdate extends Equatable {
  final String message;
  final DateTime timestamp;

  const SameProductDealUpdate({
    required this.message,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [message, timestamp];
}

class SameProductDealComment extends Equatable {
  final String id;
  final String authorName;
  final String authorAvatarUrl;
  final String text;
  final DateTime timestamp;
  final bool isHost;
  final List<SameProductDealComment> replies;

  const SameProductDealComment({
    required this.id,
    required this.authorName,
    required this.authorAvatarUrl,
    required this.text,
    required this.timestamp,
    this.isHost = false,
    this.replies = const [],
  });

  @override
  List<Object?> get props => [
        id,
        authorName,
        authorAvatarUrl,
        text,
        timestamp,
        isHost,
        replies,
      ];
}

class SameProductDealDetail extends Equatable {
  final SameProductDeal deal;
  final String description;
  final String source;
  final List<String> categoryTags;
  final SameProductDealHostInfo host;
  final DateTime deadline;
  final String pickupLocation;
  final String pickupDetail;
  final List<SameProductPricingTier> pricingTiers;
  final List<SameProductDealUpdate> updates;
  final List<SameProductDealComment> comments;

  const SameProductDealDetail({
    required this.deal,
    required this.description,
    required this.source,
    required this.categoryTags,
    required this.host,
    required this.deadline,
    required this.pickupLocation,
    required this.pickupDetail,
    required this.pricingTiers,
    this.updates = const [],
    this.comments = const [],
  });

  @override
  List<Object?> get props => [
        deal,
        description,
        source,
        categoryTags,
        host,
        deadline,
        pickupLocation,
        pickupDetail,
        pricingTiers,
        updates,
        comments,
      ];
}
