import 'package:get/get.dart';
import '../data/models/product_model.dart';

class HomeController extends GetxController {
  var allProducts = <ProductModel>[].obs;
  var filteredProducts = <ProductModel>[].obs;
  var categories = <String>[].obs;
  var selectedCategory = ''.obs;

  void filterProducts(String query) {
    filteredProducts.value = allProducts.where((product) => product.name.toLowerCase().contains(query.toLowerCase())).toList();
  }

  void extractCategories() {
    var uniqueCategories = allProducts.map((p) => p.category).toSet().toList();
    categories.assignAll(uniqueCategories);
  }

  void filterByCategory(String category) {
    selectedCategory.value = category;
    if (category.isEmpty) {
      filteredProducts.assignAll(allProducts);
    } else {
      filteredProducts.value = allProducts.where((p) => p.category == category).toList();
    }
  }
}
