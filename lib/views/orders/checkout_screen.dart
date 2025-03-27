import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/order_controller.dart';

class CheckoutScreen extends StatelessWidget {
  final CartController cartController = Get.find();
  final OrderController orderController = Get.find();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Checkout")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  var item = cartController.cartItems[index];
                  var product = item.keys.first;
                  int quantity = item.values.first;

                  return ListTile(
                    title: Text(product.name),
                    subtitle: Text(
                        "₹ ${product.price} x $quantity = ₹ ${product.price * quantity}"),
                  );
                },
              ),
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Full Name"),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: "Phone Number"),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: addressController,
              decoration: InputDecoration(labelText: "Delivery Address"),
              maxLines: 2,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                orderController.placeOrder(
                  customerName: nameController.text,
                  phoneNumber: phoneController.text,
                  address: addressController.text,
                  cartItems: cartController.cartItems,
                  totalPrice: cartController.totalPrice,
                );
              },
              child: Text("Place Order (₹ ${cartController.totalPrice})"),
            ),
          ],
        ),
      ),
    );
  }
}
