import 'package:get/get.dart';

class SettingsController extends GetxController {
  var isNotificationsEnabled = true.obs;
  var isDarkModeEnabled = false.obs;

  void toggleNotifications() {
    isNotificationsEnabled.value = !isNotificationsEnabled.value;
  }

  void toggleDarkMode() {
    isDarkModeEnabled.value = !isDarkModeEnabled.value;
  }

  void logout() {
    // Handle user logout logic
    print("User Logged Out");
    Get.offAllNamed("/login"); // Navigate to login after logout
  }
}
