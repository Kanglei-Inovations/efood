import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../admin/controllers/product_controller.dart';
import '../../admin/views/add_product_screen.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/cart_controller.dart';
import '../../data/models/product_model.dart';
import '../../data/services/firestore_service.dart';
import '../../widgets/delivery_icon.dart';

class HomeScreen extends StatelessWidget {
  final HomeController homeController = Get.find();
  final CartController cartController = Get.find();
  final AuthController authController = Get.find<AuthController>();
  final ProductController productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque, // Ensures taps are detected anywhere on the screen
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        homeController.searchController.clear(); // Clear text
        homeController.searchQuery.value = ''; // Reset search
        homeController.filterProducts(''); // Reset filter
      },  // Hide keyboard when tapping outside

      child: Scaffold(
        appBar: AppBar(
          title: Text("Food Menu"),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => Get.to(AddProductScreen()),
            ),
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () => authController.logout(),
            ),
            Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.shopping_cart),
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
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  )
                      : SizedBox()),
                ),
              ],
            ),
          ],
        ),
        body: StreamBuilder<List<ProductModel>>(
          stream: FirestoreService().streamProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("No products available"));
            }

            var foodList = snapshot.data!;
            homeController.allProducts.assignAll(foodList);
            homeController.filteredProducts.assignAll(foodList);
            homeController.extractCategories();

            return Obx(() {
              bool isSearching = homeController.searchQuery.isNotEmpty;

              return Column(
                children: [
                  // 🔍 Search Bar
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white, // Background color
                        borderRadius: BorderRadius.circular(30), // Rounded corners
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1), // Light shadow
                            blurRadius: 8,
                            spreadRadius: 2,
                            offset: Offset(0, 3), // Shadow positioning
                          ),
                        ],
                      ),
                      child: TextField(
                        textInputAction: TextInputAction.done,
                        controller: homeController.searchController,
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                        decoration: InputDecoration(
                          hintText: "Search for food...",
                          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                          prefixIcon: Icon(Icons.search, color: Colors.orangeAccent, size: 24), // Stylish search icon
                          suffixIcon: homeController.searchQuery.value.isNotEmpty
                              ? IconButton(
                            icon: Icon(Icons.clear, color: Colors.grey.shade600),
                            onPressed: () {
                              homeController.searchController.clear();
                              homeController.searchQuery.value = '';
                              homeController.filterProducts('');
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                          )
                              : null,
                          contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16), // More padding inside
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none, // No border, only shadow
                          ),
                        ),
                        onChanged: (value) {
                          homeController.searchQuery.value = value;
                          homeController.filterProducts(value);
                        },
                        onSubmitted: (_) => FocusManager.instance.primaryFocus?.unfocus(),
                      ),
                    ),
                  ),


                  // 🖼️ Banner (Hide when searching)
                  if (!isSearching)
                    Container(
                      height: 150,
                      width: MediaQuery.of(context).size.width * 0.90,
                      child: PageView.builder(
                        itemCount: foodList.length,
                        itemBuilder: (context, index) => ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            foodList[index].images.isNotEmpty ? foodList[index].images[0] : 'https://via.placeholder.com/150',
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                    ),

                  SizedBox(height: 8),

                  // 📂 Categories (Hide when searching)
                  if (!homeController.searchQuery.value.isNotEmpty)
                    Obx(() => Container(
                      width: MediaQuery.of(context).size.width,
                      // margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05), // Light shadow effect
                            blurRadius: 6,
                            spreadRadius: 2,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: homeController.categories.map((category) {
                            bool isSelected = homeController.selectedCategory.value == category;
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6),
                              child: GestureDetector(
                                onTap: () {
                                  if (isSelected) {
                                    homeController.selectedCategory.value = ''; // Deselect
                                    homeController.showAllCategories(); // Show all categories
                                  } else {
                                    homeController.filterByCategory(category); // Select new category
                                  }
                                },
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  decoration: BoxDecoration(
                                    gradient: isSelected
                                        ? LinearGradient(colors: [Colors.orangeAccent, Colors.deepOrange])
                                        : LinearGradient(colors: [Colors.grey.shade200, Colors.grey.shade300]),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: isSelected
                                        ? [
                                      BoxShadow(
                                        color: Colors.orangeAccent.withOpacity(0.4),
                                        blurRadius: 6,
                                        spreadRadius: 1,
                                      ),
                                    ]
                                        : [],
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.local_dining,
                                        size: 16,
                                        color: isSelected ? Colors.white : Colors.black54,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        category,
                                        style: TextStyle(
                                          color: isSelected ? Colors.white : Colors.black87,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    )),


                  SizedBox(height: 8),

                  // 🛒 Product Grid (Always visible)
                  Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.all(8),
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
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
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
                                        Text(food.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                        SizedBox(height: 6),

                                        // Price and Discount
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("₹${food.price}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green)),
                                            if (food.discount > 0)
                                              Text(
                                                "₹${(food.price - (food.price * food.discount / 100)).toStringAsFixed(2)}",
                                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red, decoration: TextDecoration.lineThrough),
                                              ),
                                          ],
                                        ),
                                        SizedBox(height: 6),

                                        // Icons Row (⭐ Rating, ⏳ Time)
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(children: [Icon(Icons.star, color: Colors.amber, size: 18), SizedBox(width: 4), Text("${food.rating}")]),
                                            Row(children: [Icon(Icons.timer_outlined, color: Colors.black, size: 18), SizedBox(width: 4), Text("${food.preparationTime} min")]),
                                          ],
                                        ),

                                        SizedBox(height: 8),

                                        // Add to Cart Button
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton.icon(
                                            onPressed: (food.availability && !food.isTakeawayOnly)
                                                ? () => cartController.addToCart(food)
                                                : null, // Disable when unavailable
                                            icon: Icon(Icons.add_shopping_cart, size: 18),
                                            label: Text("Add to Cart"),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: food.availability ? Colors.orange : Colors.grey,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              // Category Badge (Veg / Non-Veg)
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: food.category.toLowerCase() == 'veg' ? Colors.green : Colors.red,
                                    borderRadius: BorderRadius.circular(1),
                                  ),
                                  child: Icon(Icons.circle, size: 12, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            });
          },
        ),
      ),
    );

  }
}