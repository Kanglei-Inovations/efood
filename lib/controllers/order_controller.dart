import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/order_model.dart';
import '../data/services/firestore_service.dart';

class OrderController extends GetxController {
  var orders = <OrderModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  void fetchOrders() async {
    isLoading(true);
    try {
      var orderList = await FirestoreService().getOrders();
      orders.assignAll(orderList);
    } catch (e) {
      print("Error fetching orders: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> placeOrder(OrderModel order) async {
    try {
      await FirestoreService().createOrder(order);
      fetchOrders(); // Refresh orders after placing one
    } catch (e) {
      print("Error placing order: $e");
    }
  }
}
