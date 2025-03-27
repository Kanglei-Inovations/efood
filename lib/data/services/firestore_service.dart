import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  // Stream for real-time product updates
  Stream<List<ProductModel>> streamProducts() {
    return _firestore.collection('products').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProductModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }
  // Fetch all orders
  // 🔹 Get Orders as a Stream for Real-Time Updates
  Stream<List<OrderModel>> streamOrders() {
    return _firestore.collection("orders").orderBy("createdAt", descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return OrderModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

// Create an order
  Future<String> createOrder(OrderModel order) async {
    DocumentReference docRef = _db.collection("orders").doc();
    await docRef.set(order.toMap());
    return docRef.id; // Return generated order ID
  }

}
