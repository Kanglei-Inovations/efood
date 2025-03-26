import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bindings/auth_binding.dart';
import 'core/theme.dart';
import 'core/routes.dart';
import 'controllers/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Register AuthController before running the app
  final prefs = await SharedPreferences.getInstance();
  String? userEmail = prefs.getString("userEmail");
  runApp(MyApp(initialRoute: userEmail != null ? AppRoutes.home : AppRoutes.login));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  MyApp({required this.initialRoute});

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
