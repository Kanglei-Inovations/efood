import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../data/models/order_model.dart';

class TrackOrder extends StatelessWidget {
  final String orderId; // ✅ Use orderId instead of a static OrderModel

  const TrackOrder({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    // 🔥 Listen to Firestore changes in real-time
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('orders').doc(orderId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator())); // Show loading
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset('assets/animations/error.json', width: 200), // Error animation
                  const SizedBox(height: 20),
                  const Text("Order not found!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => Get.back(),
                    child: const Text("Go Back"),
                  ),
                ],
              ),
            ),
          );
        }

        // 🔹 Convert Firestore document to OrderModel
        OrderModel order = OrderModel.fromFirestore(snapshot.data!);

        // 🔹 Order status list
        List<String> statusList = [
          "Pending",
          "Confirmed",
          "Preparing",
          "Out for Delivery",
          "Delivered",
        ];
        int currentStep = statusList.indexOf(order.status);

        // 🔹 Lottie animation paths based on status
        Map<String, String> statusAnimations = {
          "Pending": "assets/animations/pending.json",
          "Confirmed": "assets/animations/orderconfirmed.json",
          "Preparing": "assets/animations/cooking.json",
          "Out for Delivery": "assets/animations/outfordelivery.json",
          "Delivered": "assets/animations/delivered.json",
        };

        return Scaffold(
          appBar: AppBar(title: const Text("Track Order")),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🎬 Dynamic Lottie Animation
                Center(
                  child: Lottie.asset(
                    statusAnimations[order.status] ?? 'assets/animations/pending.json',
                    width: 200,
                    height: 200,
                    repeat: true,
                  ),
                ),
                const SizedBox(height: 20),

                // 🚚 Order Tracking Progress
                const Text("Order Status", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start, // Aligns items at the top
                  children: List.generate(statusList.length, (index) {
                    return Expanded(
                      child: Column(
                        children: [
                          // ✅ Status Icon & Progress Line
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center, // Centers icons & line
                            children: [
                              // 🔹 Status Icon
                              Icon(
                                index <= currentStep ? Icons.check_circle : Icons.radio_button_unchecked,
                                color: index <= currentStep ? Colors.green : Colors.grey,
                                size: 30,
                              ),
                              // 🔹 Progress Line (except for the last item)
                              if (index < statusList.length - 1)
                                Expanded(
                                  child: Container(
                                    height: 4, // Line thickness
                                    color: index < currentStep ? Colors.green : Colors.grey[300],
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 5), // Spacing between icon & text

                          // ✅ Status Text (aligned properly)
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              statusList[index],
                              style: TextStyle(
                                color: index <= currentStep ? Colors.green : Colors.grey,
                                fontWeight: FontWeight.w600,
                                fontSize: 10, // Adjust font size for better fit
                              ),
                              textAlign: TextAlign.center, // Center align text
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 20),

                // 📦 Order Summary
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Order ID: ${order.id}", style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text("Order Date: ${order.createdAt}"),

                        Text("Customer: ${order.customerName}"),
                        Text("Phone: ${order.phoneNumber}"),
                        Text("Address: ${order.address}"),
                        const Divider(),
                        const Text("Order Items", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        ...order.cartItems?.map((item) {
                          String name = item["name"] ?? "Unknown";
                          int quantity = item["quantity"] ?? 0;
                          double price = (item["price"] ?? 0) * quantity;
                          return ListTile(
                            title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                            subtitle: Text("------- ₹$price x $quantity qty"),
                            trailing: Text("₹${price * quantity}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          );
                        }).toList() ?? [],
                        Text("Total: ₹${order.totalPrice}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
