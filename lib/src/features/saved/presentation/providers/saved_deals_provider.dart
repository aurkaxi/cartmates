import 'package:cartmates/src/imports/imports.dart';
import 'package:cartmates/src/features/deals/domain/entities/deal.dart';
import '../../data/repositories/saved_repository_impl.dart';
import '../../domain/repositories/saved_repository.dart';

final savedRepositoryProvider = Provider<SavedRepository>((ref) {
  return SavedRepositoryImpl();
});

final savedDealsProvider = FutureProvider<List<SameProductDeal>>((ref) async {
  final repo = ref.watch(savedRepositoryProvider);
  final result = await repo.getSavedDeals();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (deals) => deals,
  );
});

final dealSavedStateProvider =
    FutureProvider.family<bool, String>((ref, dealId) async {
  final repo = ref.watch(savedRepositoryProvider);
  final result = await repo.isDealSaved(dealId);
  return result.fold(
    (failure) => false,
    (saved) => saved,
  );
});
