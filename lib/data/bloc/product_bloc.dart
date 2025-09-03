import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/product.dart';
import '../database/product_helper.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductHelper dbHelper = ProductHelper();

  ProductBloc() : super(ProductInitial()) {
    on<LoadProducts>((event, emit) async {
      emit(ProductLoading());
      try {
        final data = await dbHelper.getProducts();
        final products = data.map((e) => Product.fromMap(e)).toList();
        emit(ProductLoaded(products));
      } catch (e) {
        emit(ProductError('failed to load products'));
      }
    });

    on<AddProductPressed>((event, emit) async {
      emit(ProductLoading());
      try {
        final product = Product(
          title: event.title,
          description: event.description,
          favourites: event.favourites,
          categories: event.categories,
          rating: event.rating,
        );
        await dbHelper.insertProduct(product.toMap());
        final data = await dbHelper.getProducts();
        final products = data.map((e) => Product.fromMap(e)).toList();
        emit(ProductLoaded(products));
      } catch (e) {
        emit(ProductError('Failed to add product'));
      }
    });

    on<ToggleFavourite>((event, emit) async {
      if (state is ProductLoaded) {
        final products = (state as ProductLoaded).products;
        final index = products.indexWhere((p) => p.id == event.productId);
        if (index != -1) {
          final product = products[index];
          final updatedProduct = Product(
            id: product.id,
            title: product.title,
            description: product.description,
            favourites: !product.favourites,
            categories: product.categories,
            rating: product.rating,
          );
          await dbHelper.updateProducts(product.id!, updatedProduct.toMap());
          final data = await dbHelper.getProducts();
          final updatedProducts = data.map((e) => Product.fromMap(e)).toList();
          emit(ProductLoaded(updatedProducts));
        }
      }
    });

    on<UpdateProducts>((event, emit) async {
      emit(ProductLoading());
      try {
        final product = Product(
          title: event.title,
          description: event.description,
          favourites: event.favourites,
          categories: event.categories,
          rating: event.rating,
        );
        await dbHelper.updateProducts(event.id, product.toMap());
        final data = await dbHelper.getProducts();
        final products = data.map((e) => Product.fromMap(e)).toList();
        emit(ProductLoaded(products));
      } catch (e) {
        log('$e');
        emit(ProductError('Failed to update product'));
      }
    });

    on<DeleteProducts>((event, emit) async {
      emit(ProductLoading());
      try {
        await dbHelper.deleteProduct(event.id);
        final data = await dbHelper.getProducts();
        final products = data.map((e) => Product.fromMap(e)).toList();
        emit(ProductLoaded(products));
      } catch (e) {
        emit(ProductError('Failed to delete product'));
      }
    });
  }
}
