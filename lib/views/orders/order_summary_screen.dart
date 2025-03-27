import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/order_controller.dart';
import '../../core/routes.dart';
import 'package:lottie/lottie.dart';

class OrderSummaryScreen extends StatelessWidget {
  final OrderController orderController = Get.find();

  OrderSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Auto navigate to Home after 5 seconds
    // Timer(const Duration(seconds: 5), () {
    //   Get.offAllNamed(AppRoutes.home);
    // });

    return Scaffold(
      // appBar: AppBar(title: const Text("Order Summary")),
      body: Obx(() {
        if (orderController.orders.isEmpty) {
          return const Center(child: Text("No orders yet"));
        }

        var order = orderController.orders.last;

        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ✅ Animated Tick Icon
                Lottie.asset(
                  'assets/animations/check.json', // Add a tick animation JSON from Lottie
                  width: 150,
                  height: 150,
                  repeat: false,
                ),

                const SizedBox(height: 10),
                const Text(
                  "Order Placed Successfully!",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                ),
                const SizedBox(height: 20),

                // ✅ Order Details Card
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Order ID: ${order.id}", style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Text("Customer: ${order.customerName}"),
                        Text("Phone: ${order.phoneNumber}"),
                        Text("Address: ${order.address}"),
                        const Divider(),

                        // Order Items
                        const Text("Order Items:", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        ...order.cartItems.map((item) {
                          return Text(
                            "${item["name"]} x ${item["quantity"]} = ₹${item["price"] * item["quantity"]}",
                            style: const TextStyle(fontSize: 14),
                          );
                        }).toList(),

                        const Divider(),
                        Text(
                          "Total: ₹ ${order.totalPrice}",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ✅ Back to Home Button
                ElevatedButton.icon(
                  onPressed: () {
                    Get.offAllNamed(AppRoutes.home);
                  },
                  icon: const Icon(Icons.home, color: Colors.white),
                  label: const Text("Back to Home"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
