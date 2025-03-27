import 'package:get/get.dart';
import '../data/models/order_model.dart';
import '../data/models/product_model.dart';
import '../data/services/firestore_service.dart';
import '../controllers/cart_controller.dart';
import '../views/orders/order_summary_screen.dart';

class OrderController extends GetxController {
  var orders = <OrderModel>[].obs;
  var isLoading = false.obs;
  final FirestoreService firestore = FirestoreService();
  final CartController cartController = Get.find();

  @override
  void onInit() {
    super.onInit();
    listenToOrders(); // ✅ Listen for real-time order updates
  }

  // 🔹 Real-time Firestore Orders Listener
  void listenToOrders() {
    firestore.streamOrders().listen((orderList) {
      orders.assignAll(orderList);
    }, onError: (e) {
      print("🔥 Error streaming orders: $e");
    });
  }
  // 🔹 Place an order
  Future<void> placeOrder({
    required String customerName,
    required String phoneNumber,
    required String address,
    required List<Map<ProductModel, int>> cartItems,
    required double totalPrice,
  }) async {
    try {
      if (cartController.cartItems.isEmpty) {
        Get.snackbar("Error", "Your cart is empty!");
        return;
      }

      List<Map<String, dynamic>> cartItemsJson = cartItems.map((item) {
        ProductModel product = item.keys.first;
        int quantity = item.values.first;
        return {
          'productId': product.id,
          'name': product.name,
          'price': product.price,
          'quantity': quantity,
        };
      }).toList();

      OrderModel newOrder = OrderModel(
        id: "", // Empty for now, Firestore will generate it
        customerName: customerName,
        phoneNumber: phoneNumber,
        address: address,
        cartItems: cartItemsJson,
        totalPrice: totalPrice,
        status: "Pending",
        createdAt: DateTime.now(),
      );

      // 🔹 Get the generated order ID
      String orderId = await firestore.createOrder(newOrder);
      newOrder.id = orderId; // Assign generated ID

      orders.add(newOrder);
      cartController.clearCart();

      Get.snackbar("Success", "Order placed successfully!");
      Get.to(() => OrderSummaryScreen());
    } catch (e) {
      print("🔥 Error placing order: $e");
    }
  }

}
