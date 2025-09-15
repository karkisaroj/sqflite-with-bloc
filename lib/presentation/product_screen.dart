import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqlite_usage/data/bloc/cart_bloc/cart_bloc.dart';
import 'package:sqlite_usage/data/database/product_helper.dart';
import 'package:sqlite_usage/presentation/cart_product.dart';
import 'package:sqlite_usage/presentation/product_details.dart';

import '../data/bloc/product_bloc/product_bloc.dart';
import '../data/bloc/product_bloc/product_event.dart';
import '../data/bloc/product_bloc/product_state.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late ProductBloc productBloc;
  @override
  void initState() {
    super.initState();

    context.read<ProductBloc>().add(LoadProducts());
    productBloc = context.read<ProductBloc>();
  }

  void _showAddProductDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descController = TextEditingController();
    final TextEditingController categoryController = TextEditingController();
    final TextEditingController ratingController = TextEditingController();
    final TextEditingController quantityController = TextEditingController();
    showDialog(
      context: context,
      builder: (buildContext) => BlocProvider<ProductBloc>.value(
        value: productBloc,
        child: AlertDialog(
          title: const Text('Add New Product'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: ratingController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Rating',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Quantity",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                final rate = double.tryParse(ratingController.text) ?? 0.0;
                final quantity = int.tryParse(quantityController.text) ?? 0;
                productBloc.add(
                  AddProductPressed(
                    title: titleController.text,
                    description: descController.text,
                    favourites: false,
                    categories: categoryController.text,
                    rating: rate,
                    quantity: quantity,
                  ),
                );
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        elevation: 4,
        centerTitle: true,
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, cartState) {
              int totalCartQty = 0;
              if (cartState is CartLoaded) {
                totalCartQty = cartState.products.length;
              }
              return Stack(
                alignment: Alignment.topRight,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => BlocProvider.value(
                            value: context.read<CartBloc>(),
                            child: CartProduct(),
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.shopping_cart),
                  ),
                  if (totalCartQty > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.red,
                        child: Text(
                          totalCartQty.toString(),
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductLoaded) {
            final products = state.products;
            if (products.isEmpty) {
              return const Center(
                child: Text(
                  'No products found. Tap "+" to add one!',
                  style: TextStyle(fontSize: 16),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: BlocBuilder<CartBloc, CartState>(
                    builder: (context, cartState) {
                      int cartQty = 0;
                      if (cartState is CartLoaded) {
                        cartQty = cartState.products
                            .where((p) => p.title == product.title)
                            .length;
                      }
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 16.0,
                        ),
                        title: Text(
                          product.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.production_quantity_limits_rounded,
                                  size: 18,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Available: ${product.quantity}',
                                  style: TextStyle(fontSize: 12),
                                ),
                                SizedBox(width: 12),
                                Icon(
                                  Icons.shopping_cart,
                                  size: 18,
                                  color: Colors.blue,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  cartQty.toString(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => BlocProvider.value(
                              value: BlocProvider.of<ProductBloc>(context),
                              child: ProductDetails(product: product),
                            ),
                          ),
                        ),
                        trailing: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            IconButton(
                              icon: Icon(Icons.shopping_cart),
                              tooltip: 'Add to Cart',
                              onPressed: cartQty < product.quantity
                                  ? () {
                                      context.read<CartBloc>().add(
                                        AddToCartProducts(
                                          title: product.title,
                                          description: product.description,
                                          favourites: product.favourites,
                                          categories: product.categories,
                                          rating: product.rating,
                                          quantity: 1,
                                        ),
                                      );
                                    }
                                  : null,
                            ),
                            if (cartQty > 0)
                              Positioned(
                                right: 4,
                                top: 4,
                                child: CircleAvatar(
                                  radius: 10,
                                  backgroundColor: Colors.blue,
                                  child: Text(
                                    cartQty.toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else if (state is ProductError) {
            return Center(child: Text(state.error));
          }
          return const Center(
            child: Text('Something went wrong. Please try again.'),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton.extended(
                onPressed: () {
                  ProductHelper.instance.deleteDatabaseFile();
                },
                icon: Icon(Icons.delete, color: Colors.white),
                label: Text(
                  "Delete Database",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.red,
              ),
              Spacer(),
              FloatingActionButton.extended(
                onPressed: () {
                  _showAddProductDialog(context);
                },
                icon: Icon(Icons.add, color: Colors.white),
                label: Text("Add", style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
