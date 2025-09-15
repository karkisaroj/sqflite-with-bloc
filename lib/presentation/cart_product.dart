import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqlite_usage/data/bloc/cart_bloc/cart_bloc.dart';
import 'package:sqlite_usage/data/model/product.dart';

class CartProduct extends StatelessWidget {
  const CartProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartBloc, CartState>(
      listener: (context, state) {},
      child: Scaffold(
        appBar: AppBar(title: const Text("Cart")),
        body: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoaded && state.products.isNotEmpty) {
              final Map<String, List<Product>> grouped = {};
              for (var p in state.products) {
                grouped.putIfAbsent(p.title, () => []).add(p);
              }
              final items = grouped.entries.toList();
              return ListView.separated(
                itemCount: items.length,
                separatorBuilder: (context, index) => Divider(height: 1),
                itemBuilder: (context, index) {
                  final products = items[index].value;
                  final product = products.first;
                  final qty = products.length;
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    child: ListTile(
                      title: Text(product.title),
                      subtitle: Text(product.description),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Qty: $qty',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.remove_shopping_cart),
                            tooltip: 'Remove one from Cart',
                            onPressed: () {
                              context.read<CartBloc>().add(
                                RemoveFromCartProducts(title: product.title),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return const Center(child: Text("Cart is empty"));
          },
        ),
      ),
    );
  }
}
