import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/models/product_model.dart';

class HomeController extends GetxController {
  final PageController pageController = PageController();
  var currentPage = 0.obs;
  var isSearchVisible = false.obs; // Observable for visibility
  double lastOffset = 0.0;
  var isSearchFocused = false.obs; // Observable variable
  var allProducts = <ProductModel>[].obs;
  var filteredProducts = <ProductModel>[].obs;
  var categories = <String>[].obs;
  var foodList = <ProductModel>[].obs; // Define this in your HomeController
  var selectedCategory = RxnString(); // ✅ Ensure it is nullable from the start
  FocusNode searchFocusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
    startAutoScroll();
    searchFocusNode.addListener(() {
      isSearchFocused.value = searchFocusNode.hasFocus;
    });

  }

  void startAutoScroll() {
    Timer.periodic(const Duration(seconds: 3), (timer) {

      if (filteredProducts.isEmpty) return;
      if (pageController.hasClients) {
        if (currentPage.value < filteredProducts.length - 1) {
          currentPage.value++;
        } else {
          currentPage.value = 0;
        }

        pageController.animateToPage(
          currentPage.value,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void filterProducts(String query) {
    filteredProducts.value = allProducts
        .where((product) => product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void extractCategories() {
    var uniqueCategories = allProducts.map((p) => p.category).toSet().toList();
    categories.assignAll(uniqueCategories);
  }

  void filterByCategory(String category) {
    if (selectedCategory.value == category) {
      selectedCategory.value = null; // ✅ Allow unselection
      filteredProducts.assignAll(allProducts);
    } else {
      selectedCategory.value = category;
      filteredProducts.value = allProducts.where((p) => p.category == category).toList();
    }
  }
}
