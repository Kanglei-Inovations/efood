import 'package:cached_network_image/cached_network_image.dart';
import 'package:efood/splash_screen.dart';
import 'package:efood/views/home/product_detail_screen.dart';
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
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.withOpacity(0.8)),

                borderRadius: BorderRadius.circular(10),

                // boxShadow: [
                //   BoxShadow(
                //       color: Colors.black12, blurRadius: 10, spreadRadius: 2),
                // ],
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                      'https://img.freepik.com/premium-vector/avatar-profile-icon-flat-style-male-user-profile-vector-illustration-isolated-background-man-profile-sign-business-concept_157943-38764.jpg')),
            ),
            const SizedBox(
              width: 10,
            ),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Delivery Location',
                  style: TextStyle(fontSize: 16),
                ),

                /// add location here.........
                //DropdownButton(items: items, onChanged: onChanged)
              ],
            )
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            onPressed: () => Get.to(const AddProductScreen()),
          ),
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.withOpacity(0.8))),
                child: IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () => Get.toNamed("/cart"),
                ),
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
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white),
                        ),
                      )
                    : const SizedBox()),
              ),
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.withOpacity(0.8))),
                child: IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () => Get.toNamed("/cart"),
                ),
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
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white),
                        ),
                      )
                    : const SizedBox()),
              ),
            ],
          ),
          const SizedBox(
            width: 10,
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

            return Column(crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // 🔍 Search Bar
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border:
                            Border.all(color: Colors.grey.withOpacity(0.8))),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: "Search...",
                              hintStyle: TextStyle(fontSize: 20),
                              prefixIcon: Icon(
                                Icons.search,
                                size: 30,
                              ),
                              border: InputBorder.none, // Removes all borders
                              enabledBorder: InputBorder
                                  .none, // Removes border when not focused
                              focusedBorder: InputBorder
                                  .none, // Removes border when focused
                            ),
                            onChanged: homeController.filterProducts,
                          ),
                        ),
                        MaterialButton(
                          minWidth: 40,

                          /// Scanner ..................
                          onPressed: () {},
                          child: const Icon(
                            Icons.qr_code_scanner,
                            size: 30,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                // 🖼️ Banner (Slider)
                SizedBox(
                  height: 260, // Adjust height as needed
                  child: PageView.builder(
                    itemCount: foodList.length,
                    itemBuilder: (context, index) {
                      final foodItem = foodList[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ClipPath(
                          clipper: RPSCustomClipper(),
                          child: Stack(
                            fit: StackFit.passthrough,
                            children: [
                              // Background Image
                              CachedNetworkImage(
                                imageUrl: foodItem.images.isNotEmpty
                                    ? foodItem.images[0]
                                    : 'https://ralfvanveen.com/wp-content/uploads/2021/06/Placeholder-_-Glossary-1200x675.webp',
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error,
                                        size: 50, color: Colors.red),
                              ),

                              // Dark Gradient Overlay (For better text visibility)
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.black.withOpacity(0.5),
                                      Colors.transparent
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                              ),

                              // Content (Text & Button)
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Top Dots Indicator
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: List.generate(
                                          foodList.length,
                                              (dotIndex) => Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 2),
                                            height: 6,
                                            width: dotIndex == index ? 16 : 6,
                                            decoration: BoxDecoration(
                                              color: dotIndex == index
                                                  ? Colors.orange
                                                  : Colors.white,
                                              borderRadius:
                                              BorderRadius.circular(3),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Offer Text
                                    const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Today New Offer",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "45% OFF",
                                          style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "Today 10:30 AM - 5:00 PM",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Button
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25, vertical: 12),
                                      ),
                                      onPressed: () {},
                                      child: const Text(
                                        "Get Now",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text('Categories', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                ),


                // 📂 Categories
                Obx(() => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: homeController.categories.map((category) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                    borderRadius: BorderRadius.circular(10),
                                    border:
                                    Border.all(color: Colors.grey.withOpacity(0.8))),
                                child: ChoiceChip(
                                  side: BorderSide.none,
                                  label: Text(category),
                                  selected: homeController.selectedCategory.value ==
                                      category, // ✅ Works with RxnString
                                  onSelected: (selected) {
                                    homeController.filterByCategory(category);
                                  },
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                )),

                const SizedBox(height: 8),

                // 🛒 Product Grid
                Expanded(
                  child: Obx(() => GridView.builder(
                        padding: const EdgeInsets.all(8),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              MediaQuery.of(context).size.width > 600 ? 3 : 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: homeController.filteredProducts.length,
                        itemBuilder: (context, index) {
                          var food = homeController.filteredProducts[index];
                          return GestureDetector(
                            onTap: () {
                              Get.to(() => ProductDetailsScreen(
                                  productId: food
                                      .id)); // ✅ Navigate to Track Order Page
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              elevation: 4,
                              child: Stack(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius:
                                              const BorderRadius.vertical(
                                                  top: Radius.circular(12)),
                                          child: CachedNetworkImage(
                                            imageUrl: food.images.isNotEmpty
                                                ? food.images[0]
                                                : 'https://ralfvanveen.com/wp-content/uploads/2021/06/Placeholder-_-Glossary-1200x675.webp',
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) => Center(
                                                child:
                                                    CircularProgressIndicator()), // Show loader while loading
                                            errorWidget:
                                                (context, url, error) => Icon(
                                                    Icons.error,
                                                    size: 50,
                                                    color: Colors
                                                        .red), // Show error icon if failed
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(food.name,
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            const SizedBox(height: 6),

                                            // Price and Discount
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text("₹${food.price}",
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.green)),
                                                if (food.discount > 0)
                                                  Text(
                                                    "₹${(food.price - (food.price * food.discount / 100)).toStringAsFixed(2)}",
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.red,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough),
                                                  ),
                                              ],
                                            ),
                                            const SizedBox(height: 6),

                                            // Icons Row (⭐ Rating, ⏳ Time, 📦 Packaging, 🏠 Takeaway)
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(children: [
                                                  const Icon(Icons.star,
                                                      color: Colors.amber,
                                                      size: 18),
                                                  const SizedBox(width: 4),
                                                  Text("${food.rating}")
                                                ]),
                                                Row(children: [
                                                  const Icon(Icons.timer,
                                                      color: Colors.blue,
                                                      size: 18),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                      "${food.preparationTime} min")
                                                ]),
                                              ],
                                            ),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                          Icons.local_shipping,
                                                          color: Colors.grey,
                                                          size: 18),
                                                      const SizedBox(width: 4),
                                                      Text(food.packagingType),
                                                    ],
                                                  ),
                                                  const Text("Stock"),
                                                  // Availability Status
                                                  Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Icon(
                                                        food.availability
                                                            ? Icons.check_circle
                                                            : Icons.cancel,
                                                        color: food.availability
                                                            ? Colors.green
                                                            : Colors.red,
                                                        size: 20),
                                                  ),
                                                ]),
                                            if (food.isTakeawayOnly)
                                              const Icon(Icons.shopping_bag,
                                                  color: Colors.orange,
                                                  size: 18),

                                            const SizedBox(height: 8),

                                            // Add to Cart Button
                                            SizedBox(
                                              width: double.infinity,
                                              child: ElevatedButton.icon(
                                                onPressed: () => cartController
                                                    .addToCart(food),
                                                icon: const Icon(
                                                    Icons.add_shopping_cart,
                                                    size: 18),
                                                label:
                                                    const Text("Add to Cart"),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.orange,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color:
                                            food.category.toLowerCase() == 'veg'
                                                ? Colors.green
                                                : Colors.red,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(Icons.circle,
                                          size: 12, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
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
class AACustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width * 0.00125, size.height * 0.002);
    path.lineTo(size.width, size.height * 0.002);
    path.quadraticBezierTo(
        size.width * 0.9996875, size.height * 0.6575, size.width, size.height * 0.902);
    path.quadraticBezierTo(
        size.width * 0.87375, size.height * 1.0035, size.width * 0.50125, size.height * 1.002);
    path.quadraticBezierTo(
        size.width * 0.124375, size.height * 1.001, size.width * -0.00125, size.height * 0.902);
    path.quadraticBezierTo(
        size.width * -0.000625, size.height * 0.677, size.width * 0.00125, size.height * 0.002);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false; // No need to reclip unless shape changes
  }
}
// Clipper for Banner Shape
class CustomBannerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double curveHeight = 20;

    path.lineTo(0, size.height - curveHeight);
    path.quadraticBezierTo(
        size.width * 0.5, size.height, size.width, size.height - curveHeight);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// Custom Clipper for the Unique Shape
class RPSCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width * -0.00125, size.height * 0.1);
    path.quadraticBezierTo(0, size.height * 0.001, size.width * 0.06375, 0);
    path.quadraticBezierTo(size.width * 0.14281, 0, size.width * 0.375, 0);
    path.lineTo(size.width * 0.41375, size.height * 0.1);
    path.lineTo(size.width * 0.58625, size.height * 0.1);
    path.lineTo(size.width * 0.625, 0);
    path.lineTo(size.width * 0.93875, size.height * 0.002);
    path.quadraticBezierTo(size.width * 0.99798, size.height * -0.0028, size.width, size.height * 0.102);
    path.quadraticBezierTo(size.width, size.height * 0.3015, size.width, size.height * 0.9);
    path.quadraticBezierTo(size.width * 1.00156, size.height * 1.0005, size.width * 0.93875, size.height * 1.002);
    path.quadraticBezierTo(size.width * 0.71968, size.height * 1.0015, size.width * 0.0625, size.height);
    path.quadraticBezierTo(size.width * -0.00031, size.height * 0.9985, size.width * -0.00125, size.height * 0.902);
    path.quadraticBezierTo(size.width * -0.00125, size.height * 0.7015, size.width * -0.00125, size.height * 0.1);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false; // No need to reclip unless shape changes
  }
}