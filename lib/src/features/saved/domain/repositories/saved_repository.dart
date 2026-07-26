import 'package:cartmates/src/features/deals/domain/entities/deal.dart';
import 'package:cartmates/src/utils/typedefs.dart';

abstract class SavedRepository {
  FutureEither<List<SameProductDeal>> getSavedDeals();
  FutureEither<bool> toggleSave(String dealId);
  FutureEither<bool> isDealSaved(String dealId);
}
