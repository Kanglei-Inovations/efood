import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../controllers/product_controller.dart';
import '../data/models/product_model.dart'; // For unique product ID

class AddProductScreen extends StatelessWidget {
  final ProductController productController = Get.find<ProductController>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  void addProduct() {
    if (nameController.text.isEmpty || priceController.text.isEmpty) {
      Get.snackbar("Error", "Name and Price are required");
      return;
    }

    final newProduct = ProductModel(
      id: Uuid().v4(), // Generate unique ID
      name: nameController.text,
      description: descController.text,
      price: double.parse(priceController.text),
      imageUrl: imageUrlController.text,
      category: categoryController.text,
    );

    productController.addProduct(newProduct);
    Get.back(); // Close screen after adding
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Product")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: "Name")),
            TextField(controller: descController, decoration: InputDecoration(labelText: "Description")),
            TextField(controller: priceController, decoration: InputDecoration(labelText: "Price"), keyboardType: TextInputType.number),
            TextField(controller: imageUrlController, decoration: InputDecoration(labelText: "Image URL")),
            TextField(controller: categoryController, decoration: InputDecoration(labelText: "Category")),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: addProduct,
              child: Text("Add Product"),
            ),
          ],
        ),
      ),
    );
  }
}
