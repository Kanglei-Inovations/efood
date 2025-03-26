import 'package:get/get.dart';
import '../data/models/food_model.dart';

class CartController extends GetxController {
  var cartItems = <FoodModel>[].obs;

  void addToCart(FoodModel food) {
    cartItems.add(food);
    Get.snackbar("Added", "${food.name} added to cart!");
  }

  void removeFromCart(FoodModel food) {
    cartItems.remove(food);
  }

  double get totalPrice => cartItems.fold(0, (sum, item) => sum + item.price);
}
