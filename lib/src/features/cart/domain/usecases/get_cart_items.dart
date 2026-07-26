import 'package:cartmates/src/features/cart/domain/entities/cart_item.dart';
import 'package:cartmates/src/features/cart/domain/entities/deal_status.dart';
import 'package:cartmates/src/features/cart/domain/repositories/cart_repository.dart';
import 'package:cartmates/src/utils/typedefs.dart';

class GetCartItems {
  final CartRepository repository;

  GetCartItems(this.repository);

  FutureEither<List<CartItem>> call({required CartTab tab}) {
    return repository.getCartItems(tab: tab);
  }
}
