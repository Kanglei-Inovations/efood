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
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        final user = controller.userModel.value;
        if (user == null) {
          return _buildProfileForm(); // Show form if no data exists
        }

        return _buildProfileView(user);
      }),
    );
  }

  /// Show Form if No Data Exists
  Widget _buildProfileForm() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();
    final addressController = TextEditingController();

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text("Complete Your Profile", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          TextField(controller: nameController, decoration: InputDecoration(labelText: "Name")),
          TextField(controller: phoneController, decoration: InputDecoration(labelText: "Phone")),
          TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
          TextField(controller: addressController, decoration: InputDecoration(labelText: "Address")),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              controller.saveUserData(
                name: nameController.text,
                phone: phoneController.text,
                email: emailController.text,
                address: addressController.text,
              );
            },
            child: Text("Save Profile"),
          ),
        ],
      ),
    );
  }

  /// Show User Profile Details
  Widget _buildProfileView(user) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildProfileImage(user.imageUrl),
          SizedBox(height: 20),
          _buildEditableField("Name", user.name, 'name'),
          _buildEditableField("Phone", user.phone, 'phone'),
          _buildEditableField("Email", user.email, 'email'),
          _buildEditableField("Address", user.address, 'address'),
        ],
      ),
    );
  }

  /// Profile Image
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

  /// Editable Fields
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
