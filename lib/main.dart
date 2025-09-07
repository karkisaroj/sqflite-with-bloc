import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqlite_usage/presentation/product_screen.dart';
import 'data/bloc/product_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(create: (_) => ProductBloc(), child: ProductScreen()),
    ),
  );
}
