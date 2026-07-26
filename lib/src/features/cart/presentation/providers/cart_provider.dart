import 'package:cartmates/src/imports/imports.dart';
import 'package:cartmates/src/features/cart/data/datasources/cart_local_datasource.dart';
import 'package:cartmates/src/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:cartmates/src/features/cart/domain/entities/cart_item.dart';
import 'package:cartmates/src/features/cart/domain/entities/deal_status.dart';
import 'package:cartmates/src/features/cart/domain/repositories/cart_repository.dart';
import 'package:cartmates/src/features/cart/domain/usecases/get_cart_items.dart';

final cartTabProvider = StateProvider<CartTab>((ref) => CartTab.passive);
final cartStatusFilterProvider = StateProvider<DealStatus?>((ref) => null);

final cartLocalDataSourceProvider = Provider<CartLocalDataSource>((ref) {
  return CartLocalDataSourceImpl();
});

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  final dataSource = ref.watch(cartLocalDataSourceProvider);
  return CartRepositoryImpl(localDataSource: dataSource);
});

final getCartItemsProvider = Provider<GetCartItems>((ref) {
  final repo = ref.watch(cartRepositoryProvider);
  return GetCartItems(repo);
});

final cartItemsProvider = FutureProvider<List<CartItem>>((ref) async {
  final getCartItems = ref.watch(getCartItemsProvider);
  final tab = ref.watch(cartTabProvider);
  final result = await getCartItems(tab: tab);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (items) => items,
  );
});

final filteredCartItemsProvider = Provider<List<CartItem>>((ref) {
  final items = ref.watch(cartItemsProvider).value ?? [];
  final statusFilter = ref.watch(cartStatusFilterProvider);
  if (statusFilter == null) return items;
  return items.where((item) => item.status == statusFilter).toList();
});
