// product_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/cart_controller.dart';
import '../models/product.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String productId;
  final CartController cartController = Get.find();

  ProductDetailsScreen({required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Details"),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () => Get.toNamed('/cart'),
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('products').doc(productId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text("Product not found"));
          }

          var data = snapshot.data!.data() as Map<String, dynamic>;
          final product = Product.fromMap(data, productId);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                CachedNetworkImage(
                  imageUrl: product.images.isNotEmpty ? product.images[0] : 'https://via.placeholder.com/150',
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error, size: 50, color: Colors.red),
                ),

                SizedBox(height: 10),

                // Product Name
                Text(product.name, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

                SizedBox(height: 5),

                // Price & Discount
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("₹${product.price}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                    if (product.discount > 0)
                      Text(
                        "₹${(product.price - (product.price * product.discount / 100)).toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red, decoration: TextDecoration.lineThrough),
                      ),
                  ],
                ),

                SizedBox(height: 10),

                // Rating & Preparation Time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [Icon(Icons.star, color: Colors.amber, size: 18), SizedBox(width: 4), Text("${product.rating}")]),
                    Row(children: [Icon(Icons.timer, color: Colors.blue, size: 18), SizedBox(width: 4), Text("${product.preparationTime} min")]),
                  ],
                ),

                SizedBox(height: 10),

                // Packaging Type & Availability
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.local_shipping, color: Colors.grey, size: 18),
                        SizedBox(width: 4),
                        Text(product.packagingType),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Stock: "),
                        Icon(product.availability ? Icons.check_circle : Icons.cancel,
                            color: product.availability ? Colors.green : Colors.red, size: 20),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 10),

                // Category Badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: product.category.toLowerCase() == 'veg' ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.circle, size: 12, color: Colors.white),
                      SizedBox(width: 5),
                      Text(product.category, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),

                SizedBox(height: 10),

                // Product Description
                Text("Description", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text(product.description, style: TextStyle(fontSize: 16)),

                SizedBox(height: 20),

                // Add to Cart Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => cartController.addToCart(product),
                    icon: Icon(Icons.add_shopping_cart, size: 18),
                    label: Text("Add to Cart"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(border
