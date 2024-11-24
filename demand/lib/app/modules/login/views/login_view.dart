import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/login_widget.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 185, 224, 255),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              Center(
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/icon-demand.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Email",
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.w500),
              ),
              CustomTextFormField(
                label: 'nama@gmail.com',
                controller: emailController,
              ),
              Text(
                "Password",
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.w500),
              ),
              CustomTextFormField(
                label: 'Masukkan Password',
                controller: passwordController,
                isPassword: true,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.defaultDialog(
                        title: "Forgot Password",
                        content: Column(
                          children: [
                            Text(
                              "Enter your email to receive a password reset link.",
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: emailController,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                        textConfirm: "Send",
                        onConfirm: () {
                          if (emailController.text.isNotEmpty) {
                            Get.find<LoginController>()
                                .resetPassword(emailController.text);
                            Get.back(); // Close dialog after sending reset link
                          } else {
                            Get.snackbar(
                              'Error',
                              'Please enter a valid email address.',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        },
                        textCancel: "Cancel",
                      );
                    },
                    child: Text(
                      'Forgot Password?',
                      style: GoogleFonts.workSans(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 293,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: const Color(0xff0098ff),
                  ),
                  onPressed: () async {
                    String email = emailController.text.trim();
                    String password = passwordController.text.trim();

                    try {
                      // Login dengan email dan password
                      UserCredential userCredential = await FirebaseAuth
                          .instance
                          .signInWithEmailAndPassword(
                              email: email, password: password);

                      User? user = userCredential.user;

                      if (user != null) {
                        if (user.emailVerified) {
                          // Cek apakah email user termasuk dalam daftar admin
                          const adminEmails = [
                            "11220318@nusamandiri.ac.id"
                          ];
                          if (adminEmails.contains(user.email)) {
                            // Arahkan ke Admin Dashboard
                            Get.offAllNamed('/admin-dashboard');
                          } else {
                            // Arahkan ke Home untuk user biasa
                            Get.offAllNamed('/home');
                          }
                        } else {
                          // Jika email belum terverifikasi
                          Get.defaultDialog(
                            title: "Email Not Verified",
                            middleText:
                                "Please verify your email before logging in.",
                            textConfirm: "Resend Verification",
                            textCancel: "OK",
                            onConfirm: () async {
                              await user
                                  .sendEmailVerification(); // Kirim ulang email verifikasi
                              Get.back(); // Tutup dialog
                            },
                          );
                        }
                      }
                    } on FirebaseAuthException catch (e) {
                      // Tampilkan error jika login gagal
                      Get.snackbar(
                        "Error",
                        e.message ?? "Login failed",
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  },
                  child: Text(
                    'Login',
                    style: GoogleFonts.workSans(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account?',
                    style: GoogleFonts.workSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.offNamed('/register');
                    },
                    child: Text(
                      '  Sign Up',
                      style: GoogleFonts.workSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
