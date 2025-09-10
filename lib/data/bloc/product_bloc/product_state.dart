import 'package:sqlite_usage/data/model/product.dart';

abstract class ProductState {}

final class ProductInitial extends ProductState {}

final class ProductLoading extends ProductState {}

final class ProductLoaded extends ProductState {
  final List<Product> products;
  ProductLoaded(this.products);
}

final class FavouriteAdd extends ProductState {
  final List<Product> product;
  final Set<int> favouriteIds;
  FavouriteAdd(this.product, this.favouriteIds);
}

final class ProductError extends ProductState {
  final String error;
  ProductError(this.error);
}
