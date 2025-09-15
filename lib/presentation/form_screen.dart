import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqlite_usage/data/bloc/product_bloc/product_bloc.dart';
import 'package:sqlite_usage/data/bloc/product_bloc/product_event.dart';
import 'package:sqlite_usage/data/bloc/product_bloc/product_state.dart';
import '../data/model/product.dart';

class FormScreen extends StatefulWidget {
  final Product product;

  const FormScreen({super.key, required this.product});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _categoryController;
  late final TextEditingController _ratingController;
  late final TextEditingController _qunatityController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.product.title);
    _descriptionController = TextEditingController(
      text: widget.product.description,
    );
    _categoryController = TextEditingController(
      text: widget.product.categories,
    );
    _ratingController = TextEditingController(
      text: widget.product.rating.toString(),
    );
    _qunatityController = TextEditingController(
      text: widget.product.quantity.toString(),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _ratingController.dispose();
    _qunatityController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final double rating =
        double.tryParse(_ratingController.text) ?? widget.product.rating;
    final int quantity =
        int.tryParse(_qunatityController.text) ?? widget.product.quantity;

    context.read<ProductBloc>().add(
      UpdateProducts(
        widget.product.id!,
        _titleController.text,
        _descriptionController.text,
        widget.product.favourites,
        _categoryController.text,
        rating,
        quantity,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Product updated successfully!'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Edit Product'),
            Spacer(),
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
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
                        : Icons.favorite_border_outlined,
                  ),
                );
              },
            ),
          ],
        ),
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _ratingController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Rating (0.0 - 5.0)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.star),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a rating';
                  }
                  final rating = double.tryParse(value);
                  if (rating == null || rating < 0 || rating > 10) {
                    return 'Please enter a valid rating between 0 and 10';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _qunatityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Quantity",
                  prefixIcon: Icon(Icons.add_business_rounded),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter quantity";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 32),

              ElevatedButton.icon(
                onPressed: _onSave,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.save_as_outlined),
                label: const Text('SAVE CHANGES'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
