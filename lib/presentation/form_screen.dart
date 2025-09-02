import 'package:flutter/material.dart';
import '../data/model/product.dart';

class FormScreen extends StatelessWidget {
  final Product product;

  const FormScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${product.title}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text(
              'Description: ${product.description}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 18),
            Text("Is favourite?: ${product.favourites}"),
          ],
        ),
      ),
    );
  }
}
