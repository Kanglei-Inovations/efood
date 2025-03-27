import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/cart_controller.dart';
import '../../data/models/product_model.dart';

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
                  ProductModel product = cartController.cartItems[index];
                  return ListTile(
                    leading: SizedBox(
                      width: 50,
                      child: CachedNetworkImage(
                        imageUrl: product.images.isNotEmpty
                            ? product.images[0]
                            : 'https://ralfvanveen.com/wp-content/uploads/2021/06/Placeholder-_-Glossary-1200x675.webp',
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(child: CircularProgressIndicator()), // Show loader while loading
                        errorWidget: (context, url, error) => Icon(Icons.error, size: 50, color: Colors.red), // Show error icon if failed
                      ),
                    ),
                    title: Text(product.name),
                    subtitle: Text("₹ ${product.price}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () => cartController.removeFromCart(product),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () => Get.toNamed("/order"),
                child: Text("Checkout (₹ ${cartController.totalPrice})"),
              ),
            ),
          ],
        );
      }),
    );
  }
}
