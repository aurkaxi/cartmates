import 'package:cartmates/src/config/app_config.dart';
import 'package:cartmates/src/utils/utils.dart';
import 'package:dio/dio.dart';

class SavedRemoteDatasource {
  SavedRemoteDatasource._();
  static final SavedRemoteDatasource instance = SavedRemoteDatasource._();

  Dio get _dio => AppConfig.dio;

  FutureEither<Map<String, dynamic>?> getSavedDeals() async {
    return runTask(() async {
      final response = await _dio.get<Map<String, dynamic>>('/deals/saved');
      return response.data;
    }, requiresNetwork: true);
  }

  FutureEither<Map<String, dynamic>?> toggleSave(String dealId) async {
    return runTask(() async {
      final response =
          await _dio.post<Map<String, dynamic>>('/deals/$dealId/save');
      return response.data;
    }, requiresNetwork: true);
  }

  FutureEither<Map<String, dynamic>?> isDealSaved(String dealId) async {
    return runTask(() async {
      final response =
          await _dio.get<Map<String, dynamic>>('/deals/$dealId/is-saved');
      return response.data;
    }, requiresNetwork: true);
  }
}
