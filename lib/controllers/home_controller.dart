import 'package:get/get.dart';
import '../data/models/product_model.dart';
import '../data/services/firestore_service.dart';

class HomeController extends GetxController {
  var isLoading = true.obs;
  var foodList =
      <ProductModel>[].obs; // Ensure ProductModel is correctly structured

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  void fetchProducts() async {
    try {
      isLoading(true);
      var products =
          await FirestoreService().getProducts(); // Fetch from Firestore
      if (products.isNotEmpty) {
        foodList.assignAll(products); // Update list
      } else {
        print("No products found in Firestore.");
      }
    } catch (e) {
      print("Error fetching products: $e");
    } finally {
      isLoading(false);
    }
  }
}
