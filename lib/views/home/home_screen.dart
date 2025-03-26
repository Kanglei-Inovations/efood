import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../admin/controllers/product_controller.dart';
import '../../admin/views/add_product_screen.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/cart_controller.dart';
import '../../data/models/product_model.dart';
import '../../data/services/firestore_service.dart';

class HomeScreen extends StatelessWidget {
  final HomeController homeController = Get.find();
  final CartController cartController = Get.find();
  final AuthController authController = Get.find<AuthController>();
  final ProductController productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Food Menu"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Get.to(const AddProductScreen()),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authController.logout(),
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () => Get.toNamed("/cart"),
              ),
              Positioned(
                right: 5,
                top: 5,
                child: Obx(() => cartController.cartItems.isNotEmpty
                    ? CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.red,
                  child: Text(
                    "${cartController.cartItems.length}",
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                )
                    : const SizedBox()),
              ),
            ],
          ),
        ],
      ),
      body: StreamBuilder<List<ProductModel>>(
          stream: FirestoreService().streamProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No products available"));
            }

            var foodList = snapshot.data!;
            homeController.allProducts.assignAll(foodList);
            homeController.filteredProducts.assignAll(foodList);
            homeController.extractCategories();

        return Column(
          children: [
            // 🔍 Search Bar
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onChanged: homeController.filterProducts,
              ),
            ),

            // 🖼️ Banner (Slider)
            SizedBox(
              height: 150,
              child: PageView.builder(
                itemCount: foodList.length,
                itemBuilder: (context, index) => ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(foodList[index].images.isNotEmpty ? foodList[index].images[0] : 'https://via.placeholder.com/150',
                      fit: BoxFit.cover, width: double.infinity),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // 📂 Categories
            Obx(() => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: homeController.categories.map((category) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: homeController.selectedCategory.value == category, // ✅ Works with RxnString
                      onSelected: (selected) {
                        homeController.filterByCategory(category);
                      },
                    ),
                  );
                }).toList(),
              ),


            )),

            const SizedBox(height: 8),

            // 🛒 Product Grid
            Expanded(
              child: Obx(() =>   GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.75,
                ),

                itemCount: homeController.filteredProducts.length,
                itemBuilder: (context, index) {
                  var food = homeController.filteredProducts[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                child: Image.network(
                                  food.images.isNotEmpty ? food.images[0] : 'https://via.placeholder.com/150',
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(food.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 6),

                                  // Price and Discount
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("₹${food.price}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green)),
                                      if (food.discount > 0)
                                        Text(
                                          "₹${(food.price - (food.price * food.discount / 100)).toStringAsFixed(2)}",
                                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red, decoration: TextDecoration.lineThrough),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),

                                  // Icons Row (⭐ Rating, ⏳ Time, 📦 Packaging, 🏠 Takeaway)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(children: [const Icon(Icons.star, color: Colors.amber, size: 18), const SizedBox(width: 4), Text("${food.rating}")]),
                                      Row(children: [const Icon(Icons.timer, color: Colors.blue, size: 18), const SizedBox(width: 4), Text("${food.preparationTime} min")]),

                                    ],
                                  ),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.local_shipping, color: Colors.grey, size: 18),
                                        const SizedBox(width: 4),
                                        Text(food.packagingType),
                                      ],
                                    ),
                                        const Text("Stock"),
                                    // Availability Status
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Icon(food.availability ? Icons.check_circle : Icons.cancel,
                                          color: food.availability ? Colors.green : Colors.red, size: 20),
                                    ),
                                  ]),
                                  if (food.isTakeawayOnly)
                                    const Icon(Icons.shopping_bag, color: Colors.orange, size: 18),



                                  const SizedBox(height: 8),

                                  // Add to Cart Button
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      onPressed: () => cartController.addToCart(food),
                                      icon: const Icon(Icons.add_shopping_cart, size: 18),
                                      label: const Text("Add to Cart"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        // Category Badge (Veg / Non-Veg) on Top-Left
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: food.category.toLowerCase() == 'veg' ? Colors.green : Colors.red,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.circle, size: 12, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );

                },
              )),
            ),
          ],
        );
      }),
    );
  }
}