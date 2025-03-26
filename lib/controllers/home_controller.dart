import 'package:get/get.dart';
import '../data/models/product_model.dart';
import '../data/services/firestore_service.dart';

class HomeController extends GetxController {
  var isLoading = true.obs;
  var foodList = <ProductModel>[].obs;
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void onInit() {
    super.onInit();
    listenToProducts(); // Start listening for changes
  }

  void listenToProducts() {
    _firestoreService.streamProducts().listen((products) {
      foodList.assignAll(products);
      isLoading(false);
    }, onError: (e) {
      print("Error streaming products: $e");
      isLoading(false);
    });
  }
}
