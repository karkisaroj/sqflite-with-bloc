part of 'cart_bloc.dart';

sealed class CartState {}

final class CartInitial extends CartState {}

final class CartLoading extends CartState {}

final class CartLoaded extends CartState {}

final class CartLoadingError extends CartState {
  final String error;
  CartLoadingError({required this.error});
}
