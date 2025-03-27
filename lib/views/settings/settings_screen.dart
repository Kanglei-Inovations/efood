import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../core/routes.dart';

class SettingsScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: ListView(
        children: [
          _buildSettingsItem(
            icon: Icons.person,
            title: "Profile",
            onTap: () =>  Get.offAllNamed(AppRoutes.profile), // Navigate to Profile Page
          ),
          _buildSettingsItem(
            icon: Icons.account_balance_wallet,
            title: "Bank Account",
            onTap: () => Get.toNamed('/bank_account'),
          ),

          _buildSettingsItem(
            icon: Icons.security,
            title: "Privacy & Security",
            onTap: () => Get.toNamed('/privacy_security'),
          ),
          _buildSettingsItem(
            icon: Icons.notifications,
            title: "Notifications",
            onTap: () => Get.toNamed('/notifications'),
          ),
          _buildSettingsItem(
            icon: Icons.logout,
            title: "Logout",
            onTap: () {
              authController.logout();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}
