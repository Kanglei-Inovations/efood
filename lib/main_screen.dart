import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import '../views/home/home_screen.dart';
import '../views/cart/cart_screen.dart';
import 'views/orders/order_screen.dart';
import 'views/settings/settings_screen.dart';


class MainScreen extends StatelessWidget {
  final MainController mainController = Get.put(MainController());

  final List<Widget> pages = [
    HomeScreen(),
    OrderScreen(),
    CartScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => pages[mainController.selectedIndex.value]), // Show selected page
      bottomNavigationBar: Obx(
            () => BottomNavigationBar(
          currentIndex: mainController.selectedIndex.value,
          onTap: (index) => mainController.changeTab(index),
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.history), label: "Orders"),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
          ],
        ),
      ),
    );
  }
}
