import 'package:cached_network_image/cached_network_image.dart';
import 'package:efood/splash_screen.dart';
import 'package:efood/views/home/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../admin/controllers/product_controller.dart';
import '../../admin/views/add_product_screen.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/cart_controller.dart';
import '../../data/models/product_model.dart';
import '../../data/services/firestore_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController homeController = Get.find();

  final CartController cartController = Get.find();

  final AuthController authController = Get.find<AuthController>();

  final ProductController productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    bool isVegMode = true; // Default value

    return Scaffold(
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
            return Stack(
              fit: StackFit.loose,
              children: [
                // 🖼️ Banner (Slider)
                SizedBox(
                  height: 350, // Adjust height as needed
                  child: ClipPath(
                    clipper: BCustomClipper(),
                    child: PageView.builder(
                      itemCount: foodList.length,
                      itemBuilder: (context, index) {
                        final foodItem = foodList[index];

                        return Stack(
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
                              errorWidget: (context, url, error) => const Icon(
                                  Icons.error,
                                  size: 50,
                                  color: Colors.red),
                            ),

                            // Dark Gradient Overlay (For better text visibility)
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.orangeAccent,
                                    Colors.black.withOpacity(0.5)
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 170,
                              right: 10,
                              child: Lottie.asset(
                                'assets/animations/cooking.json',
                                width: 250,
                                height: 200,
                                repeat: true,
                                fit: BoxFit.fill,
                              ),
                            ),
                            // Content (Text & Button)
                            Positioned(
                              top: 150,
                              child: Padding(
                                padding: const EdgeInsets.all(30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Top Dots Indicator
                                    Align(
                                      alignment: Alignment.topCenter,
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
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Delivery Location',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Wangkhem ▼",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),

                      /// add location here.........
                      //DropdownButton(items: items, onChanged: onChanged)
                    ],
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 20,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.admin_panel_settings),
                        onPressed: () => Get.to(const AddProductScreen()),
                      ),
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: () => Get.toNamed("/cart"),
                            child: const CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(Icons.shopping_cart,
                                  color: Colors.black),
                            ),
                          ),
                          Obx(() => cartController.cartItems.isNotEmpty
                              ? Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    height: 18,
                                    width: 18,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red),
                                    child: Center(
                                      child: Text(
                                        "${cartController.cartItems.length}",
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox()),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 90,
                  left: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(1),
                    child: Row(
                      children: [
                        Flexible(
                          // Use Flexible instead of Expanded in Positioned
                          child: Container(
                            height: 55,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Colors.grey.withOpacity(0.8)),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    focusNode: homeController.searchFocusNode,
                                    decoration: const InputDecoration(
                                      hintText: "Search...",
                                      hintStyle: TextStyle(fontSize: 20),
                                      prefixIcon: Icon(Icons.search, size: 30),
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                    ),
                                    onChanged: homeController.filterProducts,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.keyboard_voice_sharp,
                                      size: 30),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                            width: 10), // Space between search and switch
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "VEG MODE",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            Switch(
                              value: isVegMode,
                              onChanged: (value) {
                                setState(() {
                                  isVegMode = value;
                                });
                              },
                              activeColor: Colors.deepOrange,
                              inactiveTrackColor: Colors.grey,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                DraggableScrollableSheet(
                  expand: false, // Prevents auto-expanding to full screen
                  initialChildSize: 0.7, // Starts at 70% of screen height
                  minChildSize: 0.5, // Minimum 50% height
                  maxChildSize: 1.0, // Can expand to full screen
                  builder: (context, scrollController) {
                    return Obx(() {
                      if (homeController.isSearchFocused.value)
                        return const SizedBox.shrink();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 📌 Drag Indicator
                          Center(
                            child: Container(
                              margin: const EdgeInsets.only(top: 8, bottom: 4),
                              width: 40,
                              height: 5,
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),

                          // 📌 Title
                          const Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'Categories',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),

                          // 📂 Categories (Horizontal Scroll)
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children:
                                  homeController.categories.map((category) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: ChoiceChip(
                                    label: Text(category),
                                    selected:
                                        homeController.selectedCategory.value ==
                                            category,
                                    onSelected: (selected) {
                                      homeController.filterByCategory(category);
                                    },
                                    selectedColor: Colors.orange,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // 🛒 Product Grid
                          Expanded(
                            child: Obx(() => GridView.builder(
                                  controller:
                                      scrollController, // Enables scrolling inside the bottom sheet
                                  padding: const EdgeInsets.all(8),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        MediaQuery.of(context).size.width > 600
                                            ? 3
                                            : 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: 0.75,
                                  ),
                                  itemCount:
                                      homeController.filteredProducts.length,
                                  itemBuilder: (context, index) {
                                    var food =
                                        homeController.filteredProducts[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Get.to(() => ProductDetailsScreen(
                                            productId: food.id));
                                      },
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        elevation: 4,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: ClipRRect(
                                                borderRadius: const BorderRadius
                                                    .vertical(
                                                    top: Radius.circular(12)),
                                                child: CachedNetworkImage(
                                                  imageUrl: food
                                                          .images.isNotEmpty
                                                      ? food.images[0]
                                                      : 'https://ralfvanveen.com/wp-content/uploads/2021/06/Placeholder-_-Glossary-1200x675.webp',
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) =>
                                                      const Center(
                                                          child:
                                                              CircularProgressIndicator()),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error,
                                                          size: 50,
                                                          color: Colors.red),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
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

                                                  // Price & Discount
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text("₹${food.price}",
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .green)),
                                                      if (food.discount > 0)
                                                        Text(
                                                          "₹${(food.price - (food.price * food.discount / 100)).toStringAsFixed(2)}",
                                                          style: const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors.red,
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough),
                                                        ),
                                                    ],
                                                  ),

                                                  const SizedBox(height: 6),

                                                  // Rating & Time
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(children: [
                                                        const Icon(Icons.star,
                                                            color: Colors.amber,
                                                            size: 18),
                                                        const SizedBox(
                                                            width: 4),
                                                        Text("${food.rating}")
                                                      ]),
                                                      Row(children: [
                                                        const Icon(Icons.timer,
                                                            color: Colors.blue,
                                                            size: 18),
                                                        const SizedBox(
                                                            width: 4),
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
                                                      Row(children: [
                                                        const Icon(
                                                            Icons
                                                                .local_shipping,
                                                            color: Colors.grey,
                                                            size: 18),
                                                        const SizedBox(
                                                            width: 4),
                                                        Text(
                                                            food.packagingType),
                                                      ]),
                                                      const Text("Stock"),
                                                      Icon(
                                                        food.availability
                                                            ? Icons.check_circle
                                                            : Icons.cancel,
                                                        color: food.availability
                                                            ? Colors.green
                                                            : Colors.red,
                                                        size: 20,
                                                      ),
                                                    ],
                                                  ),

                                                  if (food.isTakeawayOnly)
                                                    const Icon(
                                                        Icons.shopping_bag,
                                                        color: Colors.orange,
                                                        size: 18),

                                                  const SizedBox(height: 8),

                                                  // 🛒 Add to Cart Button
                                                  SizedBox(
                                                    width: double.infinity,
                                                    child: ElevatedButton.icon(
                                                      onPressed: () =>
                                                          cartController
                                                              .addToCart(food),
                                                      icon: const Icon(
                                                          Icons
                                                              .add_shopping_cart,
                                                          size: 18),
                                                      label: const Text(
                                                          "Add to Cart"),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.orange,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8)),
                                                      ),
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
                                )),
                          ),
                        ],
                      );
                    });
                  },
                ),
              ],
            );
          }),
    );
  }
}

class BCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width * -0.00125, size.height * -0.002);
    path.lineTo(size.width, size.height * -0.002);
    path.lineTo(size.width, size.height * 0.96);
    path.quadraticBezierTo(size.width * 0.8128125, size.height * 1.001,
        size.width * 0.49875, size.height);
    path.quadraticBezierTo(
        size.width * 0.1871875, size.height, 0, size.height * 0.96);
    path.lineTo(size.width * -0.00125, size.height * -0.002);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

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
    path.quadraticBezierTo(size.width * 0.99798, size.height * -0.0028,
        size.width, size.height * 0.102);
    path.quadraticBezierTo(
        size.width, size.height * 0.3015, size.width, size.height * 0.9);
    path.quadraticBezierTo(size.width * 1.00156, size.height * 1.0005,
        size.width * 0.93875, size.height * 1.002);
    path.quadraticBezierTo(size.width * 0.71968, size.height * 1.0015,
        size.width * 0.0625, size.height);
    path.quadraticBezierTo(size.width * -0.00031, size.height * 0.9985,
        size.width * -0.00125, size.height * 0.902);
    path.quadraticBezierTo(size.width * -0.00125, size.height * 0.7015,
        size.width * -0.00125, size.height * 0.1);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false; // No need to reclip unless shape changes
  }
}
