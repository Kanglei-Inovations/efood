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
              children: [
                ClipPath(
                  clipper: BCustomClipper(),
                  child: Container(
                    width: double.infinity,
                    height: 450,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        AppBar(
                          backgroundColor: Colors.transparent,
                          title: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,

                                  borderRadius: BorderRadius.circular(10),
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
                                    style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
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
                                      ),
                                  child: IconButton(
                                    icon: const Icon(Icons.shopping_cart),
                                    onPressed: () => Get.toNamed("/cart"),
                                  ),
                                ),
                                Positioned(
                                  right: 5,
                                  top: 5,
                                  child: Obx(
                                      () => cartController.cartItems.isNotEmpty
                                          ? CircleAvatar(
                                              radius: 10,
                                              backgroundColor: Colors.red,
                                              child: Text(
                                                "${cartController.cartItems.length}",
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white),
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
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 55,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Colors.grey.withOpacity(0.8))),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          focusNode:
                                              homeController.searchFocusNode,
                                          decoration: const InputDecoration(
                                            hintText: "Search 'paratha....'",
                                            hintStyle: TextStyle(fontSize: 20),
                                            prefixIcon: Icon(
                                              color: Colors.orange,
                                              Icons.search,
                                              size: 20,
                                            ),
                                            border: InputBorder
                                                .none, // Removes all borders
                                            enabledBorder: InputBorder
                                                .none, // Removes border when not focused
                                            focusedBorder: InputBorder
                                                .none, // Removes border when focused
                                          ),
                                          onChanged:
                                              homeController.filterProducts,
                                        ),
                                      ),
                                      const VerticalDivider(width: 1, ),
                                      MaterialButton(
                                        minWidth: 40,

                                        /// Scanner ..................
                                        onPressed: () {},
                                        child: const Icon(
                                          Icons.keyboard_voice_sharp,
                                          size: 20,color: Colors.orange,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(height: 5),
                                    const Text(
                                      "VEG MODE",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),

                                    Switch(
                                      value: isVegMode,
                                      onChanged: (value) {
                                        setState(() {
                                          isVegMode = value;
                                        });
                                      },
                                      activeColor: Colors
                                          .deepOrange, // Color when switched ON
                                      inactiveTrackColor: Colors
                                          .grey, // Color when switched OFF
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        // 🖼️ Banner (Slider)
                        Obx(
                          () => homeController.isSearchFocused.value
                              ? ClipPath(clipper: CustomBannerClipper(),
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    height: 150,
                                    child: GetBuilder<HomeController>(
                                        builder: (controller) {
                                      return PageView.builder(
                                        controller: homeController.pageController,
                                        itemCount: foodList.length,
                                        onPageChanged: (index) => homeController
                                            .currentPage.value = index,
                                        itemBuilder: (context, index) {
                                          final foodItem = foodList[index];
                                          return Stack(
                                            fit: StackFit.expand,
                                            children: [
                                              // Background Image
                                              CachedNetworkImage(
                                                height: 150,
                                                imageUrl: foodItem
                                                        .images.isNotEmpty
                                                    ? foodItem.images[0]
                                                    : 'https://ralfvanveen.com/wp-content/uploads/2021/06/Placeholder-_-Glossary-1200x675.webp',
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) =>
                                                    const Center(
                                                        child:
                                                            CircularProgressIndicator()),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error,
                                                            size: 50,
                                                            color: Colors.red),
                                              ),

                                              // Dark Gradient Overlay (For better text visibility)
                                              Container(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Colors.white,
                                                      Colors.pinkAccent
                                                          .withOpacity(0.3)
                                                    ],
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                  ),
                                                ),
                                              ),

                                              // Content (Text & Button)
                                              Padding(
                                                padding: const EdgeInsets.all(30),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    // Offer Text
                                                    const Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Enjoy same prices\nas Restaurant Menu",
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(height: 5),
                                                        Text(
                                                          "Today 10:30 AM - 5:00 PM",
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.black38,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    // Button
                                                    Align(
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Colors.orange,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(30),
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal: 25,
                                                                  vertical: 12),
                                                        ),
                                                        onPressed: () {},
                                                        child: const Text(
                                                          "Order Now",
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 16),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // Top Dots Indicator
                                              Positioned(
                                                top: 10,
                                                right: 10,
                                                child: Align(
                                                  alignment: Alignment.topRight,
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: List.generate(
                                                        foodList.length,
                                                        (dotIndex) => Obx(
                                                              () => Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            2),
                                                                height: 6,
                                                                width: dotIndex ==
                                                                        homeController
                                                                            .currentPage
                                                                            .value
                                                                    ? 16
                                                                    : 6,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: dotIndex ==
                                                                          homeController
                                                                              .currentPage
                                                                              .value
                                                                      ? Colors
                                                                          .orange
                                                                      : Colors
                                                                          .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              3),
                                                                ),
                                                              ),
                                                            )),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }),
                                  ),
                              )
                              : ClipPath(
                                  clipper: BCustomClipper(),
                                  child: SizedBox(
                                    height: 250, // Adjust height as needed
                                    child: GetBuilder<HomeController>(
                                      builder: (controller) {
                                        return PageView.builder(
                                          controller: homeController.pageController,
                                          itemCount: foodList.length,
                                          onPageChanged: (index) => homeController
                                              .currentPage.value = index,
                                          itemBuilder: (context, index) {
                                            final foodItem = foodList[index];
                                            return Stack(
                                              fit: StackFit.passthrough,
                                              children: [
                                                // Background Image
                                                CachedNetworkImage(
                                                  imageUrl: foodItem
                                                          .images.isNotEmpty
                                                      ? foodItem.images[0]
                                                      : 'https://ralfvanveen.com/wp-content/uploads/2021/06/Placeholder-_-Glossary-1200x675.webp',
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) =>
                                                      const Center(
                                                          child:
                                                              CircularProgressIndicator()),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          const Icon(Icons.error,
                                                              size: 50,
                                                              color: Colors.red),
                                                ),

                                                // Dark Gradient Overlay (For better text visibility)
                                                Container(
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Colors.white,
                                                        Colors.pinkAccent
                                                            .withOpacity(0.3)
                                                      ],
                                                      begin: Alignment.topCenter,
                                                      end: Alignment.bottomCenter,
                                                    ),
                                                  ),
                                                ),

                                                // Content (Text & Button)
                                                Padding(
                                                  padding: const EdgeInsets.all(30),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      // Offer Text
                                                      const Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "Today New Offer",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors.black,
                                                              fontWeight:
                                                                  FontWeight.w500,
                                                            ),
                                                          ),
                                                          SizedBox(height: 5),
                                                          Text(
                                                            "45% OFF",
                                                            style: TextStyle(
                                                              fontSize: 30,
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              color: Colors.black87,
                                                            ),
                                                          ),
                                                          SizedBox(height: 5),
                                                          Text(
                                                            "Today 10:30 AM - 5:00 PM",
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color: Colors.black38,
                                                            ),
                                                          ),
                                                        ],
                                                      ),

                                                      // Button
                                                      ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Colors.orange,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(30),
                                                          ),
                                                          padding: const EdgeInsets
                                                              .symmetric(
                                                              horizontal: 25,
                                                              vertical: 12),
                                                        ),
                                                        onPressed: () {},
                                                        child: const Text(
                                                          "Get Now",
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 16),
                                                        ),
                                                      ),
                                                      // Top Dots Indicator
                                                      Align(
                                                        alignment: Alignment.topRight,
                                                        child: Row(
                                                          mainAxisSize:
                                                          MainAxisSize.min,
                                                          children: List.generate(
                                                              foodList.length,
                                                                  (dotIndex) => Obx(
                                                                    () => Container(
                                                                  margin:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                      2),
                                                                  height: 6,
                                                                  width: dotIndex ==
                                                                      homeController
                                                                          .currentPage
                                                                          .value
                                                                      ? 16
                                                                      : 6,
                                                                  decoration:
                                                                  BoxDecoration(
                                                                    color: dotIndex ==
                                                                        homeController
                                                                            .currentPage
                                                                            .value
                                                                        ? Colors
                                                                        .orange
                                                                        : Colors
                                                                        .white,
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                        3),
                                                                  ),
                                                                ),
                                                              )),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                DraggableScrollableSheet(
                    initialChildSize:
                        homeController.isSearchFocused.value ? 0.8 : 0.53,
                    minChildSize:
                        homeController.isSearchFocused.value ? 0.8 : 0.53,
                    maxChildSize: 0.85,
                    builder: (context, scrollController) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(
                            () => homeController.isSearchFocused.value
                                ? const SizedBox.shrink()
                                : const Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      'Categories',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                          ),
                          // 📂 Categories
                          Obx(() => homeController.isSearchFocused.value
                              ? const SizedBox.shrink()
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: homeController.categories
                                          .map((category) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.orange,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: Colors.grey
                                                        .withOpacity(0.8))),
                                            child: ChoiceChip(
                                              side: BorderSide.none,
                                              label: Text(category),
                                              selected: homeController
                                                      .selectedCategory.value ==
                                                  category, // ✅ Works with RxnString
                                              onSelected: (selected) {
                                                homeController
                                                    .filterByCategory(category);
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
                                            productId: food
                                                .id)); // ✅ Navigate to Track Order Page
                                      },
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
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
                                                        const BorderRadius
                                                            .vertical(
                                                            top:
                                                                Radius.circular(
                                                                    12)),
                                                    child: CachedNetworkImage(
                                                      imageUrl: food
                                                              .images.isNotEmpty
                                                          ? food.images[0]
                                                          : 'https://ralfvanveen.com/wp-content/uploads/2021/06/Placeholder-_-Glossary-1200x675.webp',
                                                      width: double.infinity,
                                                      fit: BoxFit.cover,
                                                      placeholder: (context,
                                                              url) =>
                                                          const Center(
                                                              child:
                                                                  CircularProgressIndicator()), // Show loader while loading
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(
                                                              Icons.error,
                                                              size: 50,
                                                              color: Colors
                                                                  .red), // Show error icon if failed
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(food.name,
                                                          style: const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
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
                                                                  color: Colors
                                                                      .red,
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
                                                            const Icon(
                                                                Icons.star,
                                                                color: Colors
                                                                    .amber,
                                                                size: 18),
                                                            const SizedBox(
                                                                width: 4),
                                                            Text(
                                                                "${food.rating}")
                                                          ]),
                                                          Row(children: [
                                                            const Icon(
                                                                Icons.timer,
                                                                color:
                                                                    Colors.blue,
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
                                                            Row(
                                                              children: [
                                                                const Icon(
                                                                    Icons
                                                                        .local_shipping,
                                                                    color: Colors
                                                                        .grey,
                                                                    size: 18),
                                                                const SizedBox(
                                                                    width: 4),
                                                                Text(food
                                                                    .packagingType),
                                                              ],
                                                            ),
                                                            const Text("Stock"),
                                                            // Availability Status
                                                            Align(
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              child: Icon(
                                                                  food.availability
                                                                      ? Icons
                                                                          .check_circle
                                                                      : Icons
                                                                          .cancel,
                                                                  color: food
                                                                          .availability
                                                                      ? Colors
                                                                          .green
                                                                      : Colors
                                                                          .red,
                                                                  size: 20),
                                                            ),
                                                          ]),
                                                      if (food.isTakeawayOnly)
                                                        const Icon(
                                                            Icons.shopping_bag,
                                                            color:
                                                                Colors.orange,
                                                            size: 18),

                                                      const SizedBox(height: 8),

                                                      // Add to Cart Button
                                                      SizedBox(
                                                        width: double.infinity,
                                                        child:
                                                            ElevatedButton.icon(
                                                          onPressed: () =>
                                                              cartController
                                                                  .addToCart(
                                                                      food),
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
                                                            shape: RoundedRectangleBorder(
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

                                            // Category Badge (Veg / Non-Veg) on Top-Left
                                            Positioned(
                                              top: 10,
                                              left: 10,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: food.category
                                                              .toLowerCase() ==
                                                          'veg'
                                                      ? Colors.green
                                                      : Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: const Icon(Icons.circle,
                                                    size: 12,
                                                    color: Colors.white),
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
