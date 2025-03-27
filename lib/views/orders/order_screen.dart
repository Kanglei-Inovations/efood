import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/order_controller.dart';

class OrderScreen extends StatelessWidget {
  final OrderController orderController = Get.find<OrderController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Your Orders")),
      body: Obx(() {
        if (orderController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (orderController.orders.isEmpty) {
          return Center(child: Text("No orders found."));
        }

        return ListView.builder(
          itemCount: orderController.orders.length,
          itemBuilder: (context, index) {
            var order = orderController.orders[index];
            return Card(
              child: ListTile(
                title: Text("Order #${order.id}"),
                subtitle: Text("Total: ₹${order.totalAmount.toStringAsFixed(2)}"),
                trailing: Text(order.status),
                onTap: () {
                  // Show order details
                },
              ),
            );
          },
        );
      }),
    );
  }
}
