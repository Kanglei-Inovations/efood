import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/routes.dart'; // Import Routes

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initPreferences();
  }

  Future<void> _initPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    String? userEmail = prefs.getString("userEmail");

    Future.delayed(const Duration(seconds: 6), () {
      if (Get.currentRoute == AppRoutes.splash) { // ✅ Check current route
        Get.offAllNamed(userEmail != null ? AppRoutes.home : AppRoutes.login);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/animations/delivery.json',
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2 * 0.9,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            const Text(
              "E-Food",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 10),
            const Text(
              "Fresh & Fast Delivery",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
