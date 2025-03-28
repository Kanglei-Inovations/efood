import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import '../../controllers/cart_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/product_model.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final CartController cartController = Get.find();
  ValueNotifier<bool> isVisible = ValueNotifier(true);
  ValueNotifier<bool> isExpanded = ValueNotifier(false);

  @override
  void dispose() {
    isVisible.dispose();
    isExpanded.dispose(); // Dispose the notifier
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('products')
            .doc(widget.productId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Product not found"));
          }

          var data = snapshot.data!.data() as Map<String, dynamic>;
          final product = ProductModel.fromMap(data, widget.productId);

          return Stack(
            fit: StackFit.loose,
            children: [
              // Full-screen Product Image
              CachedNetworkImage(
                imageUrl: product.images.isNotEmpty
                    ? product.images[0]
                    : 'https://ralfvanveen.com/wp-content/uploads/2021/06/Placeholder-_-Glossary-1200x675.webp',
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.46,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 40,
                left: 20,
                child: GestureDetector(
                  onTap: ()=>Get.to('/home'),
                  child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.arrow_back_ios))),
                ),
              ),
              // Floating Action Buttons (Favorite & Share)
              Positioned(
                top: 40,
                right: 20,
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.favorite_border, color: Colors.red),
                    ),
                    const SizedBox(width: 10),
                    const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.share, color: Colors.black),
                    ),
                    const SizedBox(width: 10),
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () => Get.toNamed("/cart"),
                          child: const CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.shopping_cart, color: Colors.black),
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

              // Product Details Section
              DraggableScrollableSheet(
                initialChildSize: 0.59,
                minChildSize: 0.59,
                maxChildSize: 0.85,
                builder: (context, scrollController) {
                  scrollController.addListener(() {
                    if (scrollController.position.userScrollDirection ==
                        ScrollDirection.reverse) {
                      isVisible.value = false; // Hide when scrolling down
                    } else if (scrollController.position.userScrollDirection ==
                        ScrollDirection.forward) {
                      isVisible.value = true; // Show when scrolling up
                    }
                  });
                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            spreadRadius: 2),
                      ],
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Name
                          Text(
                            product.name,
                            style: const TextStyle(
                                fontSize: 23, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "By McDonald's",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.star,
                                      color: Colors.amber, size: 18),
                                  const SizedBox(width: 4),
                                  Text("${product.rating}",
                                      style: const TextStyle(fontSize: 16)),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          //Seller Info
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          'https://img.freepik.com/premium-vector/avatar-profile-icon-flat-style-male-user-profile-vector-illustration-isolated-background-man-profile-sign-business-concept_157943-38764.jpg'),
                                      radius: 30,
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Arash ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text("ID: 2 ",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor:
                                          Colors.grey.withOpacity(0.2),
                                      child: const Icon(Icons.messenger_outline,
                                          color: Colors.black),
                                    ),
                                    const SizedBox(width: 20),
                                    CircleAvatar(
                                      backgroundColor:
                                          Colors.grey.withOpacity(0.2),
                                      child: const Icon(Icons.call,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Description
                          ValueListenableBuilder<bool>(
                              valueListenable: isExpanded,
                            builder: (context, expanded, child) {
                              String text = product.description;
                              bool shouldShowMore = text.length > 100; // Limit to 100 characters
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Description",
                                      style: TextStyle(
                                          fontSize: 18, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 5),

                                  Text(
                                    shouldShowMore && !expanded ? "${text.substring(0, 100)}..." : text,
                                    style: const TextStyle(fontSize: 14),
                                  ),

                                  if (shouldShowMore) // Show button only if text is long
                                    TextButton(
                                      onPressed: () => isExpanded.value = !expanded,
                                      child: Text(
                                        expanded ? "Show Less" : "Show More",
                                        style: const TextStyle(color: Colors.blue),
                                      ),
                                    ),
                                ],
                              );
                            }
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: ValueListenableBuilder<bool>(
                    valueListenable: isVisible,
                    builder: (context, visible, child) {
                      return AnimatedOpacity(
                        opacity: visible ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                  spreadRadius: 2),
                            ],
                          ),
                          height: 200,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                          color: Colors.grey.withOpacity(0.2),
                                        ),
                                        child: Row(
                                          children: [
                                            const CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: 25,
                                              child: Icon(Icons.trip_origin),
                                            ),
                                            const SizedBox(width: 10),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Delivery Time",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.grey
                                                          .withOpacity(0.8)),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                    "${product.preparationTime} min",
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                          color: Colors.grey.withOpacity(0.2),
                                        ),
                                        child: Row(
                                          children: [
                                            const CircleAvatar(
                                              radius: 25,
                                              backgroundColor: Colors.white,
                                              child: Icon(
                                                  Icons.type_specimen_outlined),
                                            ),
                                            const SizedBox(width: 10),
                                            Column(
                                              children: [
                                                Text(
                                                  "Delivery Type",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.grey
                                                          .withOpacity(0.8)),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                    "${product.packagingType} min",
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      30,
                                    ),
                                    color: Colors.orange,
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 5),
                                    leading: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Text(
                                        "\$${product.price.toStringAsFixed(2)}",
                                        style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                    trailing: Container(
                                      width: 150,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                        boxShadow: const [
                                          BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 10,
                                              spreadRadius: 2),
                                        ],
                                      ),
                                      child: TextButton(
                                        onPressed: () =>
                                            cartController.addToCart(product),
                                        child: const Text("Add to Cart",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          );
        },
      ),
    );
  }
}
