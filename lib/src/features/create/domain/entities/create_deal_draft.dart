import 'dart:io';
import 'package:equatable/equatable.dart';

class CreateDealTierDraft extends Equatable {
  final int minQty;
  final double price;

  const CreateDealTierDraft({required this.minQty, required this.price});

  CreateDealTierDraft copyWith({int? minQty, double? price}) {
    return CreateDealTierDraft(
      minQty: minQty ?? this.minQty,
      price: price ?? this.price,
    );
  }

  @override
  List<Object?> get props => [minQty, price];
}

class CreateDealDraft extends Equatable {
  final File? imageFile;
  final String name;
  final List<String> categories;
  final String sourceUrl;
  final double originalPrice;
  final int qtyGoal;
  final List<CreateDealTierDraft> pricingTiers;
  final DateTime deadline;
  final String pickupLocation;
  final String description;

  CreateDealDraft({
    this.imageFile,
    this.name = '',
    this.categories = const [],
    this.sourceUrl = '',
    this.originalPrice = 0,
    this.qtyGoal = 1,
    this.pricingTiers = const [],
    DateTime? deadline,
    this.pickupLocation = '',
    this.description = '',
  }) : deadline = deadline ?? DateTime(2099, 1, 1);

  CreateDealDraft copyWith({
    File? Function()? imageFile,
    String? name,
    List<String>? categories,
    String? sourceUrl,
    double? originalPrice,
    int? qtyGoal,
    List<CreateDealTierDraft>? pricingTiers,
    DateTime? deadline,
    String? pickupLocation,
    String? description,
  }) {
    return CreateDealDraft(
      imageFile: imageFile != null ? imageFile() : this.imageFile,
      name: name ?? this.name,
      categories: categories ?? this.categories,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      originalPrice: originalPrice ?? this.originalPrice,
      qtyGoal: qtyGoal ?? this.qtyGoal,
      pricingTiers: pricingTiers ?? this.pricingTiers,
      deadline: deadline ?? this.deadline,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      description: description ?? this.description,
    );
  }

  double get basePrice =>
      pricingTiers.isNotEmpty ? pricingTiers.first.price : originalPrice;

  int get minQtyToProceed =>
      pricingTiers.isNotEmpty ? pricingTiers.first.minQty : 1;

  bool get isImageValid => imageFile != null;

  bool get isNameValid => name.trim().isNotEmpty && name.length <= 100;

  bool get isSourceUrlValid => sourceUrl.trim().isNotEmpty;

  bool get isOriginalPriceValid => originalPrice > 0;

  bool get isQtyGoalValid => qtyGoal >= 1;

  bool get isPricingTiersValid {
    if (pricingTiers.isEmpty) return false;
    if (pricingTiers.length > 10) return false;
    for (final tier in pricingTiers) {
      if (tier.minQty < 1 || tier.price <= 0) return false;
    }
    final minQtyValues = pricingTiers.map((t) => t.minQty).toList();
    final sorted = List<int>.from(minQtyValues)..sort();
    for (int i = 0; i < sorted.length - 1; i++) {
      if (sorted[i] == sorted[i + 1]) return false;
    }
    return true;
  }

  bool get isDeadlineValid => deadline.isAfter(DateTime.now());

  bool get isPickupLocationValid => pickupLocation.trim().isNotEmpty;

  bool get isValid =>
      isNameValid &&
      isSourceUrlValid &&
      isOriginalPriceValid &&
      isQtyGoalValid &&
      isPricingTiersValid &&
      isDeadlineValid &&
      isPickupLocationValid;

  @override
  List<Object?> get props => [
        imageFile,
        name,
        categories,
        sourceUrl,
        originalPrice,
        qtyGoal,
        pricingTiers,
        deadline,
        pickupLocation,
        description,
      ];
}
