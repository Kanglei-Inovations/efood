import 'package:get/get.dart';
import '../admin/bindings/product_binding.dart';
import '../bindings/auth_binding.dart';
import '../bindings/home_binding.dart';
import '../bindings/cart_binding.dart';
import '../bindings/order_binding.dart';
import '../main_screen.dart';
import '../views/auth/login_screen.dart';
import '../views/auth/register_screen.dart';
import '../views/cart/cart_screen.dart';
import '../views/orders/order_screen.dart';

class AppRoutes {
  static const login = "/login";
  static const register = "/register";
  static const home = "/home";  // Now points to MainScreen
  static const cart = "/cart";
  static const orders = "/orders";

  static final pages = [
    GetPage(name: login, page: () => LoginScreen(), binding: AuthBinding()),
    GetPage(name: register, page: () => RegisterScreen(), binding: AuthBinding()),
    GetPage(
      name: home,
      page: () => MainScreen(), // ✅ Load MainScreen with BottomNavBar
      bindings: [HomeBinding(), ProductBinding(),OrderBinding()],
    ),
    GetPage(name: cart, page: () => CartScreen(), binding: CartBinding()),
    GetPage(name: orders, page: () => OrderScreen(), binding: OrderBinding()),
  ];
}
