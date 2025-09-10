class Product {
  final int? id;
  final String title;
  final String description;
  final bool favourites;
  final String categories;
  final double rating;
  final int quantity;

  Product({
    this.id,
    required this.title,
    required this.description,
    required this.favourites,
    required this.categories,
    required this.rating,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'favourites': favourites ? 1 : 0,
      'categories': categories,
      'rating': rating.toDouble(),
      'quantity': quantity.toInt(),
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      favourites: map['favourites'] == 1,
      categories: map['categories'],
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      quantity: map['quantity'] ?? 0,
    );
  }
}
