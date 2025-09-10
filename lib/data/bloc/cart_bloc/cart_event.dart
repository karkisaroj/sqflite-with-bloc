part of 'cart_bloc.dart';

sealed class CartEvent {}

class AddToCartProducts extends CartEvent {}

class LoadCartProducts extends CartEvent {}

class UpdateCartProducts extends CartEvent {}
