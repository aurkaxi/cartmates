import '../utils/utils.dart';
import '../config/app_config.dart';
import 'package:dio/dio.dart';

class DealsService {
  DealsService._();
  static final DealsService instance = DealsService._();

  Dio get _dio => AppConfig.dio;

  FutureEither<Map<String, dynamic>?> getClosingSoonDeals() async {
    return runTask(() async {
      final response =
          await _dio.get<Map<String, dynamic>>('/deals/closing-soon');
      return response.data;
    }, requiresNetwork: true);
  }

  FutureEither<Map<String, dynamic>?> getMaxSavingsDeals() async {
    return runTask(() async {
      final response =
          await _dio.get<Map<String, dynamic>>('/deals/max-savings');
      return response.data;
    }, requiresNetwork: true);
  }

  FutureEither<Map<String, dynamic>?> getCategories() async {
    return runTask(() async {
      final response =
          await _dio.get<Map<String, dynamic>>('/deals/categories');
      return response.data;
    }, requiresNetwork: true);
  }

  FutureEither<Map<String, dynamic>?> getSuggestedDeals(
      {String? categoryId}) async {
    return runTask(() async {
      final response = await _dio.get<Map<String, dynamic>>(
        '/deals/suggested',
        queryParameters: categoryId != null ? {'category': categoryId} : null,
      );
      return response.data;
    }, requiresNetwork: true);
  }
}
