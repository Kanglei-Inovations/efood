import 'package:get/get.dart';
import '../data/models/product_model.dart';
import '../data/services/firestore_service.dart';

class ProductController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();
  var products = <ProductModel>[].obs;
  var isLoading = false.obs;

  // Load Products from Firestore
  void fetchProducts() async {
    isLoading.value = true;
    products.value = await _firestoreService.getProducts();
    isLoading.value = false;
  }

  // Add Product to Firestore
  Future<void> addProduct(ProductModel product) async {
    await _firestoreService.addProduct(product);
    fetchProducts(); // Refresh product list after adding
  }
}
