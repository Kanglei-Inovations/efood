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
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 6));
    final prefs = await SharedPreferences.getInstance();
    String? userEmail = prefs.getString("userEmail");

    if (userEmail != null) {
      Get.offAllNamed(AppRoutes.home);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Customize background
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ✅ Lottie Animation
            Lottie.asset(
              'assets/animations/delivery.json', // Ensure the correct path
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/2*0.9,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            // ✅ App Name or Tagline
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
