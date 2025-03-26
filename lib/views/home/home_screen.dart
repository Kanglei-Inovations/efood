import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../admin/views/add_product_screen.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/cart_controller.dart';

class HomeScreen extends StatelessWidget {
  final HomeController homeController = Get.find();
  final CartController cartController = Get.find();
  final AuthController authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Food Menu"),
        actions: [

            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => Get.to(AddProductScreen()), // Navigate to Add Product Screen
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
                child: Obx(() => CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.red,
                  child: Text("${cartController.cartItems.length}", style: TextStyle(fontSize: 12, color: Colors.white)),
                )),
              ),

            ],
          ),
        ],
      ),
      body: Obx(() {
        if (homeController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: homeController.foodList.length,
          itemBuilder: (context, index) {
            var food = homeController.foodList[index];
            return ListTile(
              leading: Image.network(food.image, width: 50, height: 50, fit: BoxFit.cover),
              title: Text(food.name),
              subtitle: Text("\$${food.price}"),
              trailing: ElevatedButton(
                onPressed: () => cartController.addToCart(food),
                child: Text("Add to Cart"),
              ),
            );
          },
        );
      }),
    );
  }
}
