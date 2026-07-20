import 'package:cartmates/src/imports/imports.dart';
import '../../domain/entities/deal.dart';
import '../../domain/entities/deal_category.dart';
import '../../data/repositories/deals_repository_impl.dart';
import '../../domain/repositories/deals_repository.dart';

final dealsRepositoryProvider = Provider<DealsRepository>((ref) {
  return DealsRepositoryImpl();
});

final closingSoonProvider = FutureProvider<List<dynamic>>((ref) async {
  final repo = ref.watch(dealsRepositoryProvider);
  final result = await repo.getClosingSoonDeals();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (deals) => deals,
  );
});

final maxSavingsProvider = FutureProvider<List<SameProductDeal>>((ref) async {
  final repo = ref.watch(dealsRepositoryProvider);
  final result = await repo.getMaxSavingsDeals();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (deals) => deals,
  );
});

final categoriesProvider = FutureProvider<List<DealCategory>>((ref) async {
  final repo = ref.watch(dealsRepositoryProvider);
  final result = await repo.getCategories();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (categories) => categories,
  );
});

final selectedCategoryProvider = StateProvider<String?>((ref) => null);

final suggestedDealsProvider = FutureProvider<List<dynamic>>((ref) async {
  final repo = ref.watch(dealsRepositoryProvider);
  final categoryId = ref.watch(selectedCategoryProvider);
  final result = await repo.getSuggestedDeals(categoryId: categoryId);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (deals) => deals,
  );
});
