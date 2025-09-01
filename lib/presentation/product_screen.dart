import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqlite_usage/presentation/form_screen.dart';
import '../data/bloc/product_bloc.dart';
import '../data/bloc/product_event.dart';
import '../data/bloc/product_state.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  void initState() {
    super.initState();
    // Load products when the screen is first shown
    context.read<ProductBloc>().add(LoadProducts());
  }

  void _showAddProductDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Product'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ProductBloc>().add(
                AddProductPressed(titleController.text, descController.text),
              );
              LoadProducts;
              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductLoaded) {
            final products = state.products;
            if (products.isEmpty) {
              return const Center(child: Text('No products found.'));
            }
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final prod = products[index];
                return ListTile(
                  title: Text(prod.title),
                  subtitle: Text(prod.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FormScreen(product: prod),
                            ),
                          );
                        },
                        icon: Icon(Icons.edit),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          context.read<ProductBloc>().add(
                            DeleteProducts(prod.id!),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is ProductError) {
            return Center(child: Text(state.error));
          }
          return const Center(child: Text('Loading...'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProductDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
