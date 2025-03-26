import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/cart_controller.dart';

class CartScreen extends StatelessWidget {
  final CartController cartController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cart")),
      body: Obx(() {
        if (cartController.cartItems.isEmpty) {
          return Center(child: Text("Your cart is empty"));
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  var food = cartController.cartItems[index];
                  return ListTile(
                    leading: Image.network(food.image, width: 50, height: 50, fit: BoxFit.cover),
                    title: Text(food.name),
                    subtitle: Text("\$${food.price}"),
                    trailing: IconButton(
                      icon: Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () => cartController.removeFromCart(food),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () => Get.toNamed("/order"),
                child: Text("Checkout (\$${cartController.totalPrice})"),
              ),
            ),
          ],
        );
      }),
    );
  }
}
