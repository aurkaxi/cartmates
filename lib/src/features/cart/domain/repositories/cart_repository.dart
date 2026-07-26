import 'package:cartmates/src/features/cart/domain/entities/cart_item.dart';
import 'package:cartmates/src/features/cart/domain/entities/deal_status.dart';
import 'package:cartmates/src/utils/typedefs.dart';

abstract class CartRepository {
  FutureEither<List<CartItem>> getCartItems({required CartTab tab});
  FutureEitherVoid switchTab(CartTab tab);
}
