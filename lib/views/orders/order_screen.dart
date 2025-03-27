import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../controllers/order_controller.dart';
import '../../data/models/order_model.dart';
import '../../data/services/firestore_service.dart';
import 'track_order.dart';

class OrderScreen extends StatelessWidget {
  final OrderController orderController = Get.find<OrderController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Orders")),
      body: StreamBuilder(
        stream: FirestoreService().streamOrders(), // ✅ Listen to real-time updates
        builder: (context, AsyncSnapshot<List<OrderModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No orders found."));
          }

          var orders = snapshot.data!;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              var order = orders[index];
              Map<String, String> statusAnimations = {
                "Pending": "assets/animations/pending.json",
                "Confirmed": "assets/animations/orderconfirmed.json",
                "Preparing": "assets/animations/cooking.json",
                "Out for Delivery": "assets/animations/outfordelivery.json",
                "Delivered": "assets/animations/delivered.json",
              };
              return Card(
                child: ListTile(
                  title: Text("Order #${order.id}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Order Date: ${order.createdAt}"),
                      Text("Order Amount: ₹${order.totalPrice.toStringAsFixed(2)}"),
                    ],
                  ),
                  trailing: Column(
                    children: [
                      // Center(
                      //   child: Lottie.asset(
                      //     statusAnimations[order.status] ?? 'assets/animations/pending.json',
                      //     width: 50,
                      //     height: 50,
                      //     repeat: true,
                      //   ),
                      // ),
                      Text(order.status),
                    ],
                  ),
                  onTap: () {
                    Get.to(() => TrackOrder(orderId: order.id)); // ✅ Navigate to Track Order Page
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
