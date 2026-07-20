import 'package:cartmates/src/utils/typedefs.dart';
import 'package:cartmates/src/services/deals_service.dart';
import '../../domain/entities/deal.dart';
import '../../domain/entities/vendor_deal.dart';
import '../../domain/entities/deal_category.dart';
import '../../domain/repositories/deals_repository.dart';

class DealsRepositoryImpl implements DealsRepository {
  final DealsService _dealsService;

  DealsRepositoryImpl({DealsService? dealsService})
      : _dealsService = dealsService ?? DealsService.instance;

  @override
  FutureEither<List<SameProductDeal>> getClosingSoonDeals() async {
    final result = await _dealsService.getClosingSoonDeals();
    return result.map((data) {
      if (data == null) return <SameProductDeal>[];
      final List<dynamic> items = data['deals'] ?? data['data'] ?? [];
      return items
          .map((e) => _parseProductDeal(e as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  FutureEither<List<SameProductDeal>> getMaxSavingsDeals() async {
    final result = await _dealsService.getMaxSavingsDeals();
    return result.map((data) {
      if (data == null) return <SameProductDeal>[];
      final List<dynamic> items = data['deals'] ?? data['data'] ?? [];
      return items
          .map((e) => _parseProductDeal(e as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  FutureEither<List<DealCategory>> getCategories() async {
    final result = await _dealsService.getCategories();
    return result.map((data) {
      if (data == null) return <DealCategory>[];
      final List<dynamic> items = data['categories'] ?? data['data'] ?? [];
      return items
          .map((e) => _parseCategory(e as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  FutureEither<List<dynamic>> getSuggestedDeals({String? categoryId}) async {
    final result =
        await _dealsService.getSuggestedDeals(categoryId: categoryId);
    return result.map((data) {
      if (data == null) return <dynamic>[];
      final List<dynamic> items = data['deals'] ?? data['data'] ?? [];
      return items.map((e) {
        final map = e as Map<String, dynamic>;
        if (map['type'] == 'vendor') return _parseVendorDeal(map);
        return _parseProductDeal(map);
      }).toList();
    });
  }

  SameProductDeal _parseProductDeal(Map<String, dynamic> json) {
    return SameProductDeal(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      imageUrl: json['image_url'] ?? json['imageUrl'] ?? '',
      currentPrice:
          (json['current_price'] ?? json['currentPrice'] ?? 0).toDouble(),
      originalPrice:
          (json['original_price'] ?? json['originalPrice'] ?? 0).toDouble(),
      qtyCurrent: json['qty_current'] ?? json['qtyCurrent'] ?? 0,
      qtyGoal: json['qty_goal'] ?? json['qtyGoal'] ?? 0,
      confirmedQty: json['confirmed_qty'] ?? json['confirmedQty'] ?? 0,
      holdQty: json['hold_qty'] ?? json['holdQty'] ?? 0,
      savingsPercentage:
          (json['savings_percentage'] ?? json['savingsPercentage'] ?? 0)
              .toDouble(),
      timeRemaining: json['time_remaining'] != null
          ? Duration(seconds: json['time_remaining'] as int)
          : null,
    );
  }

  SameVendorDeal _parseVendorDeal(Map<String, dynamic> json) {
    return SameVendorDeal(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      imageUrls: List<String>.from(
        (json['image_urls'] ??
                json['imageUrls'] as List<dynamic>? ??
                <String>[])
            .map((e) => e.toString()),
      ),
      minPrice: (json['min_price'] ?? json['minPrice'] ?? 0).toDouble(),
      maxPrice: (json['max_price'] ?? json['maxPrice'] ?? 0).toDouble(),
      tag: json['tag'],
      timeRemaining: json['time_remaining'] != null
          ? Duration(seconds: json['time_remaining'] as int)
          : null,
    );
  }

  DealCategory _parseCategory(Map<String, dynamic> json) {
    return DealCategory(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      iconUrl: json['icon_url'] ?? json['iconUrl'],
    );
  }
}
