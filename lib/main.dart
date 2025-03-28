import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'bindings/auth_binding.dart';
import 'core/theme.dart';
import 'core/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: true); // Enable offline mode
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Online Food Order",
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash, // ✅ Start with Splash Screen
      getPages: AppRoutes.pages,
      initialBinding: AuthBinding(),
    );
  }
}
