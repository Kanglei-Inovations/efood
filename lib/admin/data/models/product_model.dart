class ProductModel {
  String id;
  String name;
  String description;
  double price;
  String imageUrl;
  String category;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
  });

  // Convert Product to Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
    };
  }

  // Convert Firestore Document to Product
  factory ProductModel.fromMap(Map<String, dynamic> map, String documentId) {
    return ProductModel(
      id: documentId,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: map['price'].toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      category: map['category'] ?? '',
    );
  }
}
