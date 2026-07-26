import 'package:cartmates/src/features/cart/data/datasources/cart_local_datasource.dart';
import 'package:cartmates/src/features/cart/domain/entities/cart_item.dart';
import 'package:cartmates/src/features/cart/domain/entities/deal_status.dart';
import 'package:cartmates/src/features/cart/domain/repositories/cart_repository.dart';
import 'package:cartmates/src/utils/typedefs.dart';
import 'package:fpdart/fpdart.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource _localDataSource;

  CartRepositoryImpl({required CartLocalDataSource localDataSource})
      : _localDataSource = localDataSource;

  @override
  FutureEither<List<CartItem>> getCartItems({required CartTab tab}) {
    return _localDataSource.getCartItems(tab: tab);
  }

  @override
  FutureEitherVoid switchTab(CartTab tab) async {
    return right(null);
  }
}
