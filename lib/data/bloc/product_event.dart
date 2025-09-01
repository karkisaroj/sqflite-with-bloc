abstract class ProductEvent {}

final class AddProductPressed extends ProductEvent {
  final String title;
  final String description;
  AddProductPressed(this.title, this.description);
}

final class LoadProducts extends ProductEvent {}

final class UpdateProducts extends ProductEvent {
  final int id;
  final String title;
  final String description;
  UpdateProducts(this.id, this.title, this.description);
}

final class DeleteProducts extends ProductEvent {
  final int id;
  DeleteProducts(this.id);
}
