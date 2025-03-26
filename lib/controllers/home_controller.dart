import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/food_model.dart';

class HomeController extends GetxController {
  var foodList = <FoodModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchFoodItems();
    super.onInit();
  }

  Future<void> fetchFoodItems() async {
    try {
      isLoading(true);
      var snapshot = await FirebaseFirestore.instance.collection("food_items").get();
      foodList.assignAll(snapshot.docs.map((doc) => FoodModel.fromSnapshot(doc)));
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }
}
