import 'package:sqlite_usage/data/model/product.dart';

abstract class ProductState {}

final class ProductInitial extends ProductState {}

final class ProductLoading extends ProductState {}

final class ProductLoaded extends ProductState {
  final List<Product> products;
  ProductLoaded(this.products);
}

final class ProductError extends ProductState {
  final String error;
  ProductError(this.error);
}
