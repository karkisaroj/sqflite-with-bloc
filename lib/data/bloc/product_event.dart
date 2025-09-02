abstract class ProductEvent {}

final class AddProductPressed extends ProductEvent {
  final String title;
  final String description;
  final bool favourites;
  AddProductPressed(this.title, this.description, this.favourites);
}

final class LoadProducts extends ProductEvent {}

final class UpdateProducts extends ProductEvent {
  final int id;
  final String title;
  final String description;
  final bool favourites;
  UpdateProducts(this.id, this.title, this.description, this.favourites);
}

final class ToggleFavourite extends ProductEvent {
  final int productId;
  ToggleFavourite(this.productId);
}

final class DeleteProducts extends ProductEvent {
  final int id;
  DeleteProducts(this.id);
}
