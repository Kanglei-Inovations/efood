import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bindings/auth_binding.dart';
import 'controllers/order_controller.dart';
import 'core/theme.dart';
import 'core/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final prefs = await SharedPreferences.getInstance();
  String? userEmail = prefs.getString("userEmail");
  // Get.put(OrderController());
  runApp(MyApp(initialRoute: userEmail != null ? AppRoutes.home : AppRoutes.login));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Online Food Order",
      theme: AppTheme.lightTheme,
      initialRoute: initialRoute,
      getPages: AppRoutes.pages,
      initialBinding: AuthBinding(), // ✅ Ensure AuthController is initialized globally
    );
  }
}
