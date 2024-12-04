import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileCompletionController extends GetxController {
  final usernameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final bioController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> submitProfile() async {
    try {
      final currentUser = _auth.currentUser;

      if (currentUser == null) throw Exception("No user is logged in");

      final name =
          "${firstNameController.text.trim()} ${lastNameController.text.trim()}";

      final data = {
        "username": usernameController.text.trim(),
        "name": name,
        "email": currentUser.email,
        "phone": phoneController.text.trim(),
        "bio": bioController.text.trim(),
        "profilePicture":
            "https://ui-avatars.com/api/?name=$name&background=random",
        "role": "user",
        "license": false,
      };

      await _firestore.collection("users").doc(currentUser.uid).set(data);
      Get.snackbar("Success", "Profile updated successfully!",
          backgroundColor: Colors.green, colorText: Colors.white);

      Get.offAllNamed("/login");
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
