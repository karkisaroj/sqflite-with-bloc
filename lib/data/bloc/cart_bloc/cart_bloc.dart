import 'package:bloc/bloc.dart';
import 'package:sqlite_usage/data/model/product.dart';
import 'package:sqlite_usage/data/database/product_helper.dart';
part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final List<Product> _cart = [];
  final _helper = ProductHelper.instance;
  CartBloc() : super(CartInitial()) {
    add(LoadCartProducts());
    on<AddToCartProducts>((event, emit) async {
      final product = Product(
        title: event.title,
        description: event.description,
        favourites: event.favourites,
        categories: event.categories,
        rating: event.rating,
        quantity: event.quantity,
      );
      await _helper.insertCartProduct(product.toMap());
      final cartMaps = await _helper.getCartProducts();
      _cart
        ..clear()
        ..addAll(cartMaps.map((m) => Product.fromMap(m)));
      emit(CartLoaded(products: List.from(_cart)));
    });
    on<RemoveFromCartProducts>((event, emit) async {
      // Remove one instance of product from cart
      final cartMaps = await _helper.getCartProducts();
      final toRemove = cartMaps.firstWhere(
        (m) => m['title'] == event.title,
        orElse: () => {},
      );
      if (toRemove.isNotEmpty && toRemove['id'] != null) {
        await _helper.deleteCartProduct(toRemove['id']);
      }
      final updatedCartMaps = await _helper.getCartProducts();
      _cart
        ..clear()
        ..addAll(updatedCartMaps.map((m) => Product.fromMap(m)));
      emit(CartLoaded(products: List.from(_cart)));
    });
    on<LoadCartProducts>((event, emit) async {
      final cartMaps = await _helper.getCartProducts();
      _cart
        ..clear()
        ..addAll(cartMaps.map((m) => Product.fromMap(m)));
      emit(CartLoaded(products: List.from(_cart)));
    });
  }
}
