import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream for real-time product updates
  Stream<List<ProductModel>> streamProducts() {
    return _firestore.collection('products').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProductModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }
  // Fetch all orders
  Future<List<OrderModel>> getOrders() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('orders').orderBy('createdAt', descending: true).get();
      return snapshot.docs
          .map((doc) => OrderModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print("Error fetching orders: $e");
      return [];
    }
  }

// Create an order
  Future<void> createOrder(OrderModel order) async {
    try {
      await _firestore.collection('orders').add(order.toMap());
    } catch (e) {
      print("Error creating order: $e");
    }
  }

}
