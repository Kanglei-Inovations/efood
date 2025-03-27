import 'dart:io';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import '../data/models/user_model.dart';

class ProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  Rx<UserModel?> userModel = Rx<UserModel?>(null);

  User? get user => _auth.currentUser;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  void fetchUserData() async {
    if (user != null) {
      DocumentSnapshot snapshot = await _firestore.collection('users').doc(user!.uid).get();
      if (snapshot.exists) {
        userModel.value = UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
      }
    }
  }

  Future<void> updateUserData(String field, String value) async {
    if (user != null) {
      await _firestore.collection('users').doc(user!.uid).update({field: value});
      fetchUserData(); // Refresh user data
    }
  }

  Future<void> updateProfileImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      // Implement Firebase Storage Upload Here
      userModel.value = userModel.value!.copyWith(imageUrl: pickedFile.path);
      await updateUserData('imageUrl', pickedFile.path);
    }
  }

}
