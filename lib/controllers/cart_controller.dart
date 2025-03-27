import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/product_model.dart';

class CartController extends GetxController {
  var cartItems = <Map<ProductModel, int>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadCart();
  }

  void addToCart(ProductModel product) {
    var existingItem = cartItems.firstWhereOrNull((item) => item.containsKey(product));
    if (existingItem != null) {
      existingItem[product] = existingItem[product]! + 1;
    } else {
      cartItems.add({product: 1});
    }
    saveCart();
    cartItems.refresh(); // Update UI
  }

  void removeFromCart(ProductModel product) {
    var existingItem = cartItems.firstWhereOrNull((item) => item.containsKey(product));
    if (existingItem != null) {
      int currentQty = existingItem[product]!;
      if (currentQty > 1) {
        existingItem[product] = currentQty - 1;
      } else {
        cartItems.remove(existingItem);
      }
      saveCart();
      cartItems.refresh();
    }
  }

  double get totalPrice {
    return cartItems.fold(0, (sum, item) {
      var product = item.keys.first;
      var quantity = item.values.first;
      return sum + (product.price * quantity);
    });
  }

  Future<void> saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cartJson = cartItems.map((item) {
      var product = item.keys.first;
      int quantity = item.values.first;
      return jsonEncode({"product": product.toJson(), "quantity": quantity});
    }).toList();
    await prefs.setStringList("cartItems", cartJson);
  }

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? cartJson = prefs.getStringList("cartItems");
    if (cartJson != null) {
      cartItems.value = cartJson.map((item) {
        var decoded = jsonDecode(item);
        ProductModel product = ProductModel.fromJson(decoded["product"]);
        int quantity = decoded["quantity"];
        return {product: quantity};
      }).toList();
    }
  }
  void clearCart() async {
    cartItems.clear(); // Clear the cart items in memory
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("cartItems"); // Clear saved cart data in SharedPreferences
    Get.snackbar("Cart Cleared", "Your cart is now empty.");
    cartItems.refresh(); // Refresh the UI
  }

}
