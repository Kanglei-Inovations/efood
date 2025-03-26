import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../controllers/product_controller.dart';
import '../data/models/product_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final ProductController productController = Get.find<ProductController>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  String? selectedCategory;
  String? selectedSubCategory;
  String? selectedPackagingType;
  bool isAvailable = true;
  bool isTakeawayOnly = false;
  List<File> selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  final TextEditingController preparationTimeController = TextEditingController(); // ✅
  final List<String> categories = ["Veg", "Non-Veg","Juice","Desserts" ];
  final Map<String, List<String>> subCategories = {
    "Veg": ["Salads", "Pasta", "Pizza"],
    "Non-Veg": ["Chicken", "Fish", "Mutton", "Beef"],
    "Juice" : ["Orange", "Apple", "Mango", "Pineapple"],
    "Desserts": ["Cake", "Ice Cream", "Pudding"]

  };
  final List<String> packagingOptions = ["Eco-Friendly","Plastic Box", "Paper Wrap", "Foil"];

  // Image Picker
  Future<void> pickImages() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        selectedImages = pickedFiles.map((file) => File(file.path)).toList();
      });
    }
  }

  // Upload Images to Firebase Storage
  Future<List<String>> uploadImages() async {
    List<String> imageUrls = [];
    for (var image in selectedImages) {
      String fileName = Uuid().v4();
      Reference ref = FirebaseStorage.instance.ref().child("products/$fileName.jpg");
      await ref.putFile(image);
      String imageUrl = await ref.getDownloadURL();
      imageUrls.add(imageUrl);
    }
    return imageUrls;
  }

  void addProduct() async {
    if (nameController.text.isEmpty || priceController.text.isEmpty || selectedCategory == null) {
      Get.snackbar("Error", "Name, Price, and Category are required", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    List<String> imageUrls = await uploadImages(); // Upload images first

    final newProduct = ProductModel(
      id: Uuid().v4(),
      name: nameController.text,
      description: descController.text,
      price: double.parse(priceController.text),
      images: imageUrls, // Store image URLs
      category: selectedCategory!,
      subCategory: selectedSubCategory ?? "",
      availability: isAvailable,
      rating: 0.0, // Default rating
      createdAt: Timestamp.now(), // ✅ Fix applied here
      discount: discountController.text.isEmpty ? 0.0 : double.parse(discountController.text),
      isPopular: false, // Set later based on sales
      preparationTime: preparationTimeController.text.isEmpty ? 15 : int.parse(preparationTimeController.text), // Default time
      packagingType: selectedPackagingType ?? "",
      isTakeawayOnly: isTakeawayOnly,
    );

    productController.addProduct(newProduct);
    Get.back(); // Close screen after adding
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Product")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Name Input
            TextField(controller: nameController, decoration: InputDecoration(labelText: "Product Name")),
            // Description Input
            TextField(controller: descController, decoration: InputDecoration(labelText: "Description")),
            // Price Input
            TextField(controller: priceController, decoration: InputDecoration(labelText: "Price"), keyboardType: TextInputType.number),
            // Discount Input
            TextField(controller: discountController, decoration: InputDecoration(labelText: "Discount (Optional)"), keyboardType: TextInputType.number),

            // Category Dropdown
            DropdownButtonFormField<String>(
              value: selectedCategory,
              hint: Text("Select Category"),
              items: categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                  selectedSubCategory = null; // Reset sub-category
                });
              },
            ),

            // Sub-Category Dropdown (Based on Selected Category)
            if (selectedCategory != null)
              DropdownButtonFormField<String>(
                value: selectedSubCategory,
                hint: Text("Select Sub-Category"),
                items: subCategories[selectedCategory]?.map((sub) => DropdownMenuItem(value: sub, child: Text(sub))).toList(),
                onChanged: (value) => setState(() => selectedSubCategory = value),
              ),

            // Packaging Type Dropdown
            DropdownButtonFormField<String>(
              value: selectedPackagingType,
              hint: Text("Select Packaging Type"),
              items: packagingOptions.map((pack) => DropdownMenuItem(value: pack, child: Text(pack))).toList(),
              onChanged: (value) => setState(() => selectedPackagingType = value),
            ),

            // Image Picker Button
            ElevatedButton.icon(
              onPressed: pickImages,
              icon: Icon(Icons.image),
              label: Text("Select Images"),
            ),

            // Display Selected Images
            if (selectedImages.isNotEmpty)
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: selectedImages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Image.file(selectedImages[index], width: 80, height: 80, fit: BoxFit.cover),
                    );
                  },
                ),
              ),
            // ✅ Added Preparation Time Field
            TextField(
              controller: preparationTimeController,
              decoration: InputDecoration(labelText: "Preparation Time (in minutes)"),
              keyboardType: TextInputType.number,
            ),
            // Availability Switch
            SwitchListTile(
              title: Text("Available"),
              value: isAvailable,
              onChanged: (value) => setState(() => isAvailable = value),
            ),

            // Takeaway Only Switch
            SwitchListTile(
              title: Text("Takeaway Only"),
              value: isTakeawayOnly,
              onChanged: (value) => setState(() => isTakeawayOnly = value),
            ),

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
