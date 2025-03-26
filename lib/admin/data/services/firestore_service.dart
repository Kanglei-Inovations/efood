import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add Product to Firestore
  Future<void> addProduct(ProductModel product) async {
    try {
      await _firestore.collection('products').doc(product.id).set(product.toMap());
    } catch (e) {
      print("Error adding product: $e");
    }
  }

  // Fetch All Products
  Future<List<ProductModel>> getProducts() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('products').get();
      return snapshot.docs
          .map((doc) => ProductModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print("Error fetching products: $e");
      return [];
    }
  }
}
