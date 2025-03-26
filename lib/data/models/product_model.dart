import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String id;
  String name;
  String description;
  double price;
  List<String> images; // Can store multiple image URLs
  String category; // Veg/Non-Veg
  String subCategory; // E.g., Chicken, Fish, Juice types
  bool availability;
  double rating;
  Timestamp createdAt;
  double discount;
  bool isPopular;
  int preparationTime; // In minutes
  String packagingType; // Plastic Box, Paper Wrap, etc.
  bool isTakeawayOnly;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.images,
    required this.category,
    required this.subCategory,
    required this.availability,
    required this.rating,
    required this.createdAt,
    required this.discount,
    required this.isPopular,
    required this.preparationTime,
    required this.packagingType,
    required this.isTakeawayOnly,
  });

  // Convert Product to Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'images': images, // Store as an array
      'category': category,
      'subCategory': subCategory,
      'availability': availability,
      'rating': rating,
      'createdAt': createdAt,
      'discount': discount,
      'isPopular': isPopular,
      'preparationTime': preparationTime,
      'packagingType': packagingType,
      'isTakeawayOnly': isTakeawayOnly,
    };
  }

  // Convert Firestore Document to ProductModel
  factory ProductModel.fromMap(Map<String, dynamic> map, String documentId) {
    return ProductModel(
      id: documentId,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] != null) ? (map['price'] as num).toDouble() : 0.0,
      images: List<String>.from(map['images'] ?? []), // Ensure it's a list
      category: map['category'] ?? '',
      subCategory: map['subCategory'] ?? '',
      availability: map['availability'] ?? false,
      rating: (map['rating'] != null) ? (map['rating'] as num).toDouble() : 0.0,
      createdAt: map['createdAt'] ?? Timestamp.now(),
      discount: (map['discount'] != null) ? (map['discount'] as num).toDouble() : 0.0,
      isPopular: map['isPopular'] ?? false,
      preparationTime: map['preparationTime'] ?? 0,
      packagingType: map['packagingType'] ?? '',
      isTakeawayOnly: map['isTakeawayOnly'] ?? false,
    );
  }
}
