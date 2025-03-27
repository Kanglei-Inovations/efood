import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../data/models/user_model.dart';

class ProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  Rx<UserModel?> userModel = Rx<UserModel?>(null);
  RxBool isLoading = true.obs; // Show loading while fetching data

  User? get user => _auth.currentUser;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  /// Fetch User Data from Firestore
  void fetchUserData({int retryCount = 0}) async {
    if (user != null) {
      try {
        DocumentSnapshot snapshot = await _firestore.collection('users').doc(user!.uid).get();

        if (snapshot.exists) {
          userModel.value = UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
        } else {
          userModel.value = null; // No profile found
        }
      } catch (e) {
        print("Firestore Error: $e");

        if (retryCount < 3) { // Limit retries to 3
          await Future.delayed(Duration(seconds: 5));
          fetchUserData(retryCount: retryCount + 1);
        } else {
          Get.snackbar("Error", "Failed to fetch data. Please check your internet connection.");
        }
      } finally {
        isLoading.value = false; // Ensure loading stops
      }
    } else {
      print("User not logged in");
      isLoading.value = false;
    }
  }



  /// Save or Update User Data in Firestore
  Future<void> saveUserData({required String name, required String phone, required String email, required String address}) async {
    if (user != null) {
      final newUser = UserModel(
        uid: user!.uid,
        name: name,
        phone: phone,
        email: email,
        address: address,
        imageUrl: userModel.value?.imageUrl ?? '',
      );

      await _firestore.collection('users').doc(user!.uid).set(newUser.toMap());
      userModel.value = newUser; // Update locally
      Get.snackbar("Success", "Profile Updated");
    }
  }

  /// Update a Single Field
  Future<void> updateUserData(String field, String value) async {
    if (user != null) {
      await _firestore.collection('users').doc(user!.uid).update({field: value});
      fetchUserData(); // Refresh data
    }
  }

  /// Update Profile Image
  Future<void> updateProfileImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      userModel.value = userModel.value?.copyWith(imageUrl: pickedFile.path);
      await updateUserData('imageUrl', pickedFile.path);
    }
  }
}
