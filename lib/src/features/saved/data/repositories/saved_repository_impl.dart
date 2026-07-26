import 'package:cartmates/src/features/deals/domain/entities/deal.dart';
import 'package:cartmates/src/utils/typedefs.dart';
// TODO(api-migration): Uncomment remote datasource when API is ready
// import '../datasources/saved_remote_datasource.dart';
import '../datasources/saved_local_datasource.dart';
import '../../domain/repositories/saved_repository.dart';

class SavedRepositoryImpl implements SavedRepository {
  // TODO(api-migration): Change type to SavedRemoteDatasource
  final SavedLocalDatasource _datasource;

  // TODO(api-migration): Change default to SavedRemoteDatasource.instance
  SavedRepositoryImpl({SavedLocalDatasource? datasource})
      : _datasource = datasource ?? SavedLocalDatasource.instance;

  @override
  FutureEither<List<SameProductDeal>> getSavedDeals() async {
    final result = await _datasource.getSavedDeals();
    return result.map((items) {
      return items.map((e) => _parseProductDeal(e)).toList();
    });
  }

  @override
  FutureEither<bool> toggleSave(String dealId) async {
    return await _datasource.toggleSave(dealId);
  }

  @override
  FutureEither<bool> isDealSaved(String dealId) async {
    return await _datasource.isDealSaved(dealId);
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
}
