import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  String id;
  String customerName;
  String phoneNumber;
  String address;
  List<Map<String, dynamic>> cartItems;
  double totalPrice;
  String status;
  DateTime createdAt;

  OrderModel({
    required this.id,
    required this.customerName,
    required this.phoneNumber,
    required this.address,
    required this.cartItems,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
  });

  // 🔹 Convert OrderModel to Firestore Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerName': customerName,
      'phoneNumber': phoneNumber,
      'address': address,
      'cartItems': cartItems,
      'totalPrice': totalPrice,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt), // Convert DateTime to Firestore Timestamp
    };
  }
  // ✅ Factory constructor to convert Firestore data into OrderModel
  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return OrderModel(
      id: doc.id, // Firestore document ID
      customerName: data['customerName'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      address: data['address'] ?? '',
      status: data['status'] ?? 'Pending',
      totalPrice: (data['totalPrice'] ?? 0).toDouble(),
      cartItems: List<Map<String, dynamic>>.from(data['cartItems'] ?? []),
      createdAt: (data["createdAt"] as Timestamp).toDate(),
    );
  }
  // 🔹 Convert Firestore Document to OrderModel
  factory OrderModel.fromMap(Map<String, dynamic> map, String documentId) {
    return OrderModel(
      id: documentId,
      customerName: map['customerName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      address: map['address'] ?? '',
      cartItems: List<Map<String, dynamic>>.from(map['cartItems'] ?? []),
      totalPrice: (map['totalPrice'] as num).toDouble(),
      status: map['status'] ?? 'Pending',
      createdAt: (map['createdAt'] as Timestamp).toDate(), // Convert Firestore Timestamp to DateTime
    );
  }
}
