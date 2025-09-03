abstract class ProductEvent {}

final class AddProductPressed extends ProductEvent {
  final String title;
  final String description;
  final bool favourites;
  final String categories;
  final double rating;
  AddProductPressed({
    required this.title,
    required this.description,
    required this.favourites,
    required this.categories,
    required this.rating,
  });
}

final class LoadProducts extends ProductEvent {}

final class UpdateProducts extends ProductEvent {
  final int id;
  final String title;
  final String description;
  final bool favourites;
  final String categories;
  final double rating;
  UpdateProducts(
    this.id,
    this.title,
    this.description,
    this.favourites,
    this.categories,
    this.rating,
  );
}

final class ToggleFavourite extends ProductEvent {
  final int productId;
  ToggleFavourite(this.productId);
}

final class DeleteProducts extends ProductEvent {
  final int id;
  DeleteProducts(this.id);
}
