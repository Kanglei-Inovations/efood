import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  String id;
  String userId;
  List<Map<String, dynamic>> items; // List of items in the order
  double totalAmount;
  String status; // Pending, Completed, Canceled
  Timestamp createdAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map, String docId) {
    return OrderModel(
      id: docId,
      userId: map['userId'],
      items: List<Map<String, dynamic>>.from(map['items']),
      totalAmount: map['totalAmount'].toDouble(),
      status: map['status'],
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'items': items,
      'totalAmount': totalAmount,
      'status': status,
      'createdAt': createdAt,
    };
  }
}
