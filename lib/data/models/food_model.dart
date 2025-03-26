import 'package:cloud_firestore/cloud_firestore.dart';

class FoodModel {
  String id;
  String name;
  double price;
  String image;

  FoodModel({required this.id, required this.name, required this.price, required this.image});

  factory FoodModel.fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return FoodModel(
      id: snapshot.id,
      name: data["name"],
      price: data["price"].toDouble(),
      image: data["image"],
    );
  }
}
