import 'package:get/get.dart';
import '../data/models/product_model.dart';

class CartController extends GetxController {
  var cartItems = <ProductModel>[].obs;

  void addToCart(ProductModel product) {
    cartItems.add(product);
  }

  void removeFromCart(ProductModel product) {
    cartItems.remove(product);
  }

  double get totalPrice {
    return cartItems.fold(0, (sum, item) => sum + item.price);
  }
}
