part of 'cart_bloc.dart';

sealed class CartEvent {}

class AddToCartProducts extends CartEvent {
  final String title;
  final String description;
  final bool favourites;
  final String categories;
  final double rating;
  final int quantity;
  AddToCartProducts({
    required this.title,
    required this.description,
    required this.favourites,
    required this.categories,
    required this.rating,
    required this.quantity,
  });
}

class RemoveFromCartProducts extends CartEvent {
  final String title;
  RemoveFromCartProducts({required this.title});
}

class LoadCartProducts extends CartEvent {}
