import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../controllers/product_controller.dart';
import '../data/models/product_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  AddProductScreenState createState() => AddProductScreenState();
}

class AddProductScreenState extends State<AddProductScreen> {
  final ProductController productController = Get.find<ProductController>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController preparationTimeController = TextEditingController();
  String? selectedCategory;
  String? selectedSubCategory;
  String? selectedPackagingType;
  bool isAvailable = true;
  bool isTakeawayOnly = false;
  List<File> selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  final List<String> categories = ["Veg", "Non-Veg", "Juice", "Desserts"];
  final Map<String, List<String>> subCategories = {
    "Veg": ["Salads", "Pasta", "Pizza"],
    "Non-Veg": ["Chicken", "Fish", "Mutton", "Beef"],
    "Juice": ["Orange", "Apple", "Mango", "Pineapple"],
    "Desserts": ["Cake", "Ice Cream", "Pudding"],
  };
  final List<String> packagingOptions = ["Eco-Friendly", "Plastic Box", "Paper Wrap", "Foil"];

  // Image Picker
  Future<void> pickImages() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        selectedImages = pickedFiles.map((file) => File(file.path)).toList();
      });
    }
  }

  Future<void> checkAuth() async {
    if (FirebaseAuth.instance.currentUser == null) {
      await FirebaseAuth.instance.signInAnonymously();
    }
  }

  // Upload Images to Firebase Storage
  Future<List<String>> uploadImages() async {
    checkAuth();
    List<String> imageUrls = [];
    for (var image in selectedImages) {
      String fileName = const Uuid().v4();
      Reference ref = FirebaseStorage.instance.ref().child("products/$fileName.jpg");
      await ref.putFile(image);
      String imageUrl = await ref.getDownloadURL();
      if (kDebugMode) {
        print("Uploaded Image URL: $imageUrl");
      }
      imageUrls.add(imageUrl);
    }
    return imageUrls;
  }

  void addProduct() async {
    checkAuth();
    if (nameController.text.isEmpty || priceController.text.isEmpty || selectedCategory == null) {
      Get.snackbar("Error", "Name, Price, and Category are required", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    List<String> imageUrls = await uploadImages();

    final newProduct = ProductModel(
      id: const Uuid().v4(),
      name: nameController.text,
      description: descController.text,
      price: double.parse(priceController.text),
      images: imageUrls,
      category: selectedCategory!,
      subCategory: selectedSubCategory ?? "",
      availability: isAvailable,
      rating: 0.0,
      createdAt: Timestamp.now(),
      discount: discountController.text.isEmpty ? 0.0 : double.parse(discountController.text),
      isPopular: false,
      preparationTime: preparationTimeController.text.isEmpty ? 15 : int.parse(preparationTimeController.text),
      packagingType: selectedPackagingType ?? "",
      isTakeawayOnly: isTakeawayOnly,
    );

    productController.addProduct(newProduct);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Product"), backgroundColor: Colors.green),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Product Name
                buildTextField("Product Name", nameController),

                // Description
                buildTextField("Description", descController),

                // Price & Discount Row
                Row(
                  children: [
                    Expanded(child: buildTextField("Price", priceController, isNumber: true)),
                    const SizedBox(width: 10),
                    Expanded(child: buildTextField("Discount", discountController, isNumber: true)),
                  ],
                ),

                // Category Dropdown
                buildDropdown("Select Category", categories, selectedCategory, (value) {
                  setState(() {
                    selectedCategory = value;
                    selectedSubCategory = null;
                  });
                }),

                // Sub-Category Dropdown
                if (selectedCategory != null)
                  buildDropdown("Select Sub-Category", subCategories[selectedCategory] ?? [], selectedSubCategory, (value) {
                    setState(() => selectedSubCategory = value);
                  }),

                // Packaging Type Dropdown
                buildDropdown("Select Packaging Type", packagingOptions, selectedPackagingType, (value) {
                  setState(() => selectedPackagingType = value);
                }),

                // Image Picker Button
                ElevatedButton.icon(
                  onPressed: pickImages,
                  icon: const Icon(Icons.image),
                  label: const Text("Select Images"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),

                // Display Selected Images
                if (selectedImages.isNotEmpty)
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: selectedImages.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Image.file(selectedImages[index], width: 80, height: 80, fit: BoxFit.cover),
                            ),
                            Positioned(
                              right: 0,
                              child: IconButton(
                                icon: const Icon(Icons.cancel, color: Colors.red),
                                onPressed: () => setState(() => selectedImages.removeAt(index)),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                // Preparation Time
                buildTextField("Preparation Time (min)", preparationTimeController, isNumber: true),

                // Availability Switch
                SwitchListTile(
                  title: const Text("Available"),
                  value: isAvailable,
                  onChanged: (value) => setState(() => isAvailable = value),
                  activeColor: Colors.green,
                ),

                // Takeaway Only Switch
                SwitchListTile(
                  title: const Text("Takeaway Only"),
                  value: isTakeawayOnly,
                  onChanged: (value) => setState(() => isTakeawayOnly = value),
                  activeColor: Colors.green,
                ),

                const SizedBox(height: 20),

                // Add Product Button
                ElevatedButton(
                  onPressed: addProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  ),
                  child: const Text("Add Product", style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      ),
    );
  }

  Widget buildDropdown(String hint, List<String> items, String? value, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField(
        decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        value: value,
        hint: Text(hint),
        items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
