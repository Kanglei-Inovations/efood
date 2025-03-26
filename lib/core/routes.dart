import 'package:get/get.dart';
import '../admin/bindings/product_binding.dart';
import '../views/auth/login_screen.dart';
import '../views/auth/register_screen.dart';
import '../views/home/home_screen.dart';
import '../views/cart/cart_screen.dart';
import '../bindings/auth_binding.dart';
import '../bindings/home_binding.dart';
import '../bindings/cart_binding.dart';

class AppRoutes {
  static const login = "/login";
  static const register = "/register";
  static const home = "/home";
  static const cart = "/cart";

  static final pages = [
    GetPage(name: login, page: () => LoginScreen(), binding: AuthBinding()),
    GetPage(name: register, page: () => RegisterScreen(), binding: AuthBinding()),
    GetPage(
      name: home,
      page: () => HomeScreen(),
      bindings: [HomeBinding(), ProductBinding()], // ✅ Use "bindings" instead of "binding"
    ),
    GetPage(name: cart, page: () => CartScreen(), binding: CartBinding()),
  ];
}
