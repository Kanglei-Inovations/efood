import 'package:get/get.dart';
import '../views/auth/login_screen.dart';
import '../views/auth/register_screen.dart';
import '../views/home/home_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';

  static List<GetPage> pages = [
    GetPage(name: login, page: () => LoginScreen()),
    GetPage(name: register, page: () => RegisterScreen()),
    GetPage(name: home, page: () => HomeScreen()),
  ];
}
