import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/routes.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var user = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    user.bindStream(_auth.authStateChanges());
    _loadUser(); // Load user when the app starts
  }

  void register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await _saveUser(email);
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  void login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await _saveUser(email);
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  void logout() async {
    await _auth.signOut();
    await _clearUser();
    Get.offAllNamed(AppRoutes.login);
  }

  /// Save user email in SharedPreferences
  Future<void> _saveUser(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("userEmail", email);
  }

  /// Load user from SharedPreferences
  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString("userEmail");

    if (email != null) {
      Future.delayed(const Duration(seconds: 2), () => Get.offAllNamed(AppRoutes.home));
    }
  }

  /// Clear user data when logging out
  Future<void> _clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("userEmail");
  }
}
