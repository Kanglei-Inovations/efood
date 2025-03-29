import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../controllers/cart_controller.dart';
import '../controllers/profile_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
    Get.put(CartController());
    Get.put(ProfileController());
  }
}
