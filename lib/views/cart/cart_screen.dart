import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/cart_controller.dart';
import '../../data/models/product_model.dart';

import '../orders/checkout_screen.dart'; // ✅ Import CheckoutScreen

class CartScreen extends StatelessWidget {
  final CartController cartController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cart")),
      body: Obx(() {
        if (cartController.cartItems.isEmpty) {
          return const Center(child: Text("Your cart is empty"));
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  var item = cartController.cartItems[index];
                  ProductModel product = item.keys.first;
                  int quantity = item.values.first;

                  return ListTile(
                    leading: SizedBox(
                      width: 50,
                      child: CachedNetworkImage(
                        imageUrl: product.images.isNotEmpty
                            ? product.images[0]
                            : 'https://ralfvanveen.com/wp-content/uploads/2021/06/Placeholder-_-Glossary-1200x675.webp',
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => const Icon(Icons.error, size: 50, color: Colors.red),
                      ),
                    ),
                    title: Text(product.name),
                    subtitle: Text("₹ ${product.price} x $quantity = ₹ ${product.price * quantity}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle, color: Colors.red),
                          onPressed: () => cartController.removeFromCart(product),
                        ),
                        Text(quantity.toString(), style: TextStyle(fontSize: 18)),
                        IconButton(
                          icon: const Icon(Icons.add_circle, color: Colors.green),
                          onPressed: () => cartController.addToCart(product),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () => Get.to(() => CheckoutScreen()), // ✅ Navigate to Checkout
                child: Text("Checkout (₹ ${cartController.totalPrice})"),
              ),
            ),
          ],
        );
      }),
    );
  }
}
