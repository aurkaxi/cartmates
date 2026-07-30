import '../../domain/repositories/create_deal_repository.dart';
import '../../domain/entities/create_deal_draft.dart';
import '../datasources/create_deal_mock_datasource.dart';
import '../../../deals/domain/entities/same_product_deal_detail.dart';

class CreateDealRepositoryImpl implements CreateDealRepository {
  final CreateDealMockDatasource _datasource;

  CreateDealRepositoryImpl({CreateDealMockDatasource? datasource})
      : _datasource = datasource ?? CreateDealMockDatasource.instance;

  @override
  Future<SameProductDealDetail> createSameProductDeal(CreateDealDraft draft) {
    return _datasource.createDeal(draft);
  }
}
