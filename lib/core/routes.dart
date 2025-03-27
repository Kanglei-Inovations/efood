import 'package:get/get.dart';

import '../admin/bindings/product_binding.dart';
import '../bindings/auth_binding.dart';
import '../bindings/home_binding.dart';
import '../bindings/cart_binding.dart';
import '../bindings/order_binding.dart';
import '../bindings/profile_binding.dart'; // ✅ Added Profile Binding
import '../bindings/settings_binding.dart'; // ✅ Added Settings Binding

import '../main_screen.dart';
import '../splash_screen.dart';
import '../views/auth/login_screen.dart';
import '../views/auth/register_screen.dart';
import '../views/cart/cart_screen.dart';
import '../views/orders/order_screen.dart';
import '../views/profile/profile_screen.dart'; // ✅ Profile Screen
import '../views/settings/settings_screen.dart'; // ✅ Settings Screen

class AppRoutes {
  static const splash = "/"; // ✅ Start with SplashScreen
  static const login = "/login";
  static const register = "/register";
  static const home = "/home";  // Now points to MainScreen
  static const cart = "/cart";
  static const orders = "/orders";
  static const profile = "/profile";  // ✅ Added Profile Route
  static const settings = "/settings";  // ✅ Added Settings Route

  static final pages = [
    GetPage(name: splash, page: () => SplashScreen()), // ✅ Splash First
    GetPage(name: login, page: () => LoginScreen(), binding: AuthBinding()),
    GetPage(name: register, page: () => RegisterScreen(), binding: AuthBinding()),
    GetPage(
      name: home,
      page: () => MainScreen(), // ✅ Load MainScreen with BottomNavBar
      bindings: [HomeBinding(), ProductBinding(), OrderBinding()],
    ),
    GetPage(name: cart, page: () => CartScreen(), binding: CartBinding()),
    GetPage(name: orders, page: () => OrderScreen(), binding: OrderBinding()),

    // ✅ New Routes for Profile & Settings
    GetPage(name: profile, page: () => ProfileScreen(), binding: ProfileBinding()),
    GetPage(name: settings, page: () => SettingsScreen(), binding: SettingsBinding()),
  ];
}
