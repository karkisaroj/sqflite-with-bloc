import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqlite_usage/data/bloc/product_bloc/product_bloc.dart';
import 'package:sqlite_usage/data/bloc/product_bloc/product_event.dart';
import 'package:sqlite_usage/data/bloc/product_bloc/product_state.dart';
import 'package:sqlite_usage/data/model/product.dart';

class ProductDetails extends StatefulWidget {
  final Product product;
  const ProductDetails({super.key, required this.product});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
        actions: [
          BlocBuilder<ProductBloc, ProductState>(
            builder: (ctx, state) {
              Product currentProduct = widget.product;
              if (state is ProductLoaded) {
                final updated = state.products.firstWhere(
                  (p) => p.id == widget.product.id,
                  orElse: () => widget.product,
                );
                currentProduct = updated;
              }
              return IconButton(
                onPressed: () {
                  context.read<ProductBloc>().add(
                    UpdateProducts(
                      currentProduct.id!,
                      currentProduct.title,
                      currentProduct.description,
                      !currentProduct.favourites,
                      currentProduct.categories,
                      currentProduct.rating,
                      currentProduct.quantity,
                    ),
                  );
                },
                icon: Icon(
                  currentProduct.favourites
                      ? Icons.favorite
                      : Icons.favorite_border_rounded,
                  color: currentProduct.favourites ? Colors.red : null,
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Chip(
                      label: Text(widget.product.categories),
                      backgroundColor: Colors.blue.shade50,
                    ),
                    Spacer(),
                    Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 20),
                            SizedBox(width: 4),
                            Text(widget.product.rating.toString()),
                          ],
                        ),
                        SizedBox(height: 30),
                        Row(
                          children: [
                            Icon(Icons.production_quantity_limits_rounded),
                            SizedBox(width: 5),
                            Text(widget.product.quantity.toString()),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  widget.product.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
