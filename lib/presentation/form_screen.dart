import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqlite_usage/data/bloc/product_bloc.dart';
import 'package:sqlite_usage/data/bloc/product_event.dart';
import 'package:sqlite_usage/data/bloc/product_state.dart';
import '../data/model/product.dart';

class FormScreen extends StatefulWidget {
  final Product product;

  const FormScreen({super.key, required this.product});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController ratingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product Details')),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return Center(child: const CircularProgressIndicator());
          }
          if (state is ProductLoaded) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: widget.product.title,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      hintText: widget.product.description == ''
                          ? 'Emty Descripton'
                          : widget.product.description,
                      hintStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                    ),
                  ),
                  TextField(
                    controller: categoryController,
                    decoration: InputDecoration(
                      labelText: widget.product.categories == ''
                          ? 'Emty Category'
                          : widget.product.categories,
                      hintStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                    ),
                  ),

                  TextField(
                    controller: ratingController,
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: widget.product.rating.toDouble().toString(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                    ),
                  ),
                  Spacer(),
                  Center(
                    child: IconButton(
                      onPressed: () {
                        final String rateText = ratingController.text;
                        final double? rate = double.tryParse(rateText);
                        context.read<ProductBloc>().add(
                          UpdateProducts(
                            widget.product.id!,
                            titleController.text,
                            descriptionController.text,
                            widget.product.favourites,
                            categoryController.text,
                            rate ?? 0.0,
                          ),
                        );
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.save_as),
                      iconSize: 60,
                    ),
                  ),
                ],
              ),
            );
          }
          return Center(child: Text("Loading ..."));
        },
      ),
    );
  }
}
