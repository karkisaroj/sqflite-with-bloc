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
        emit(ProductError('Failed to load products'));
      }
    });

    on<AddProductPressed>((event, emit) async {
      emit(ProductLoading());
      try {
        await dbHelper.insertProduct({
          'title': event.title,
          'description': event.description,
        });
        final data = await dbHelper.getProducts();
        final products = data.map((e) => Product.fromMap(e)).toList();
        emit(ProductLoaded(products));
      } catch (e) {
        emit(ProductError('Failed to add product'));
      }
    });

    on<UpdateProducts>((event, emit) async {
      emit(ProductLoading());
      try {
        await dbHelper.updateProduct(event.id, {
          'title': event.title,
          'description': event.description,
        });
        final data = await dbHelper.getProducts();
        final products = data.map((e) => Product.fromMap(e)).toList();
        emit(ProductLoaded(products));
      } catch (e) {
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
