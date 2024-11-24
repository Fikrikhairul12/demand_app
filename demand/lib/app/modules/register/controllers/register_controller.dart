import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Rx<User?> user = Rx<User?>(null);
  Timer? verificationTimer; // Timer untuk memantau verifikasi email

  @override
  void onInit() {
    super.onInit();
    user.bindStream(_auth.authStateChanges()); // Pantau perubahan user
  }

  @override
  void onClose() {
    verificationTimer
        ?.cancel(); // Pastikan timer dihentikan saat controller ditutup
    super.onClose();
  }

  Future<void> reloadUser() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      await currentUser.reload();
      user.value = _auth.currentUser; // Update nilai `user`
    }
  }

  Future<void> registerUser(String email, String password) async {
    try {
      print("Register process started");
      // Buat user baru
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print("User registered successfully");
      User? newUser = result.user;

      if (newUser != null && !newUser.emailVerified) {
        // Kirim email verifikasi
        await newUser.sendEmailVerification();
        print("Verification email sent to $email");

        // Tampilkan dialog instruksi
        Get.defaultDialog(
          title: "Email Verification",
          middleText:
              "A verification email has been sent to $email. Please verify your email.",
          textConfirm: "OK",
          onConfirm: () => Get.back(),
        );

        // Mulai memantau status verifikasi
        monitorVerification();
      }
    } on FirebaseAuthException catch (e) {
      // Tangani error
      print("Error during registration: ${e.message}");
      Get.snackbar(
        "Error",
        e.message ?? "Registration failed",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void monitorVerification() {
    // Mulai timer untuk memeriksa status verifikasi setiap 5 detik
    verificationTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
      print("Checking verification status...");
      await reloadUser();

      if (user.value?.emailVerified ?? false) {
        print("Email verified!");
        timer.cancel(); // Hentikan timer

        // Tampilkan dialog hanya jika belum terbuka
        if (!Get.isDialogOpen!) {
          print("Dialog is open: ${Get.isDialogOpen}");
          Get.defaultDialog(
            title: "Verification Successful",
            middleText: "Your email has been successfully verified.",
            textConfirm: "OK",
            onConfirm: () {
              Get.back(); // Tutup dialog
              Get.offAllNamed('/home'); // Arahkan ke halaman home
            },
          );
        }
      } else {
        print("Email not yet verified...");
      }
    });
  }
}
