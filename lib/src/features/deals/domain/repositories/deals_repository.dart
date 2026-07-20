import 'package:cartmates/src/utils/typedefs.dart';
import '../entities/deal.dart';
import '../entities/deal_category.dart';

abstract class DealsRepository {
  FutureEither<List<SameProductDeal>> getClosingSoonDeals();
  FutureEither<List<SameProductDeal>> getMaxSavingsDeals();
  FutureEither<List<DealCategory>> getCategories();
  FutureEither<List<dynamic>> getSuggestedDeals({String? categoryId});
}
