import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqlite_usage/presentation/form_screen.dart';

import '../data/bloc/product_bloc.dart';
import '../data/bloc/product_event.dart';
import '../data/bloc/product_state.dart';
import '../data/model/product.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(LoadProducts());
  }

  void _showAddProductDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descController = TextEditingController();
    final TextEditingController categoryController = TextEditingController();
    final TextEditingController ratingController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Product'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
              context.read<ProductBloc>().add(
                AddProductPressed(
                  title: titleController.text,
                  description: descController.text,
                  favourites: false,
                  categories: categoryController.text,
                  rating: rate,
                ),
              );
              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showProductDetails(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(product.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product.description),
            const SizedBox(height: 16),
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium,
                children: [
                  const TextSpan(
                    text: 'Category: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: product.categories),
                ],
              ),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium,
                children: [
                  const TextSpan(
                    text: 'Rating: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: '${product.rating} / 5.0'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products'), elevation: 4),
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
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 16.0,
                    ),
                    title: Text(
                      product.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      product.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () => _showProductDetails(context, product),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: 'Favorite',
                          onPressed: () {
                            context.read<ProductBloc>().add(
                              ToggleFavourite(product.id!),
                            );
                          },
                          icon: product.favourites
                              ? const Icon(Icons.favorite, color: Colors.red)
                              : const Icon(Icons.favorite_border),
                        ),
                        IconButton(
                          tooltip: 'Edit',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider.value(
                                  value: context.read<ProductBloc>(),
                                  child: FormScreen(product: product),
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit_outlined),
                        ),
                        IconButton(
                          tooltip: 'Delete',
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.redAccent,
                          ),
                          onPressed: () {
                            context.read<ProductBloc>().add(
                              DeleteProducts(product.id!),
                            );
                          },
                        ),
                      ],
                    ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProductDialog(context),
        tooltip: 'Add Product',
        child: const Icon(Icons.add),
      ),
    );
  }
}
