class Product {
  final int? id;
  final String title;
  final String description;

  Product({this.id, required this.title, required this.description});

  // Convert a Product into a Map.
  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'description': description};
  }

  // Create a Product from a Map.
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      title: map['title'],
      description: map['description'],
    );
  }
}
