import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/profile_controller.dart';


class ProfileScreen extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          final user = controller.userModel.value;
          if (user == null) {
            return Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              _buildProfileImage(user.imageUrl),
              SizedBox(height: 20),
              _buildEditableField("Name", user.name, 'name'),
              _buildEditableField("Phone", user.phone, 'phone'),
              _buildEditableField("Email", user.email, 'email'),
              _buildEditableField("Address", user.address, 'address'),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildProfileImage(String imageUrl) {
    return GestureDetector(
      onTap: () => controller.updateProfileImage(),
      child: CircleAvatar(
        radius: 50,
        backgroundImage: imageUrl.isNotEmpty ? FileImage(File(imageUrl)) : AssetImage('assets/profile_placeholder.png') as ImageProvider,
        child: Align(
          alignment: Alignment.bottomRight,
          child: CircleAvatar(
            backgroundColor: Colors.blue,
            radius: 15,
            child: Icon(Icons.camera_alt, size: 15, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildEditableField(String label, String value, String field) {
    return ListTile(
      title: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value.isNotEmpty ? value : "Tap to update"),
      trailing: Icon(Icons.edit, color: Colors.blue),
      onTap: () {
        Get.defaultDialog(
          title: "Update $label",
          content: TextField(
            controller: TextEditingController(text: value),
            decoration: InputDecoration(border: OutlineInputBorder()),
            onSubmitted: (newValue) {
              if (newValue.isNotEmpty) {
                controller.updateUserData(field, newValue);
                Get.back();
              }
            },
          ),
        );
      },
    );
  }
}
