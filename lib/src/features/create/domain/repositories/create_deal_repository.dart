import '../entities/create_deal_draft.dart';
import '../../../deals/domain/entities/same_product_deal_detail.dart';

abstract class CreateDealRepository {
  Future<SameProductDealDetail> createSameProductDeal(CreateDealDraft draft);
}
