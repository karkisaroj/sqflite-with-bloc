part of 'cart_bloc.dart';

sealed class CartState {}

final class CartInitial extends CartState {}

final class CartLoading extends CartState {}

final class CartLoaded extends CartState {
  final List<Product> products;
  CartLoaded({required this.products});
}

final class CartAdded extends CartState {
  final List<Product> products;
  final Set<int> cartId;
  CartAdded({required this.cartId, required this.products});
}

final class CartLoadingError extends CartState {
  final String error;
  CartLoadingError({required this.error});
}
