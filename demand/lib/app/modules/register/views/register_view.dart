import 'package:firebase_auth/firebase_auth.dart';
import 'package:demand/app/widgets/login_widget.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});
  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

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
              SizedBox(height: 10),
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
              Text(
                "Konfirmasi Password",
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.w500),
              ),
              CustomTextFormField(
                label: 'Masukkan Kembali Password',
                controller: confirmPasswordController,
                isPassword: true,
              ),
              SizedBox(
                width: 293,
                height: 60,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Color(0xff0098ff),
                    ),
                    onPressed: () async {
                      String email = emailController.text;
                      String password = passwordController.text;
                      String confirmPassword = confirmPasswordController.text;

                      if (password == confirmPassword) {
                        await controller.registerUser(email, password);
                      } else {
                        // Password tidak sama
                        Get.snackbar(
                          "Error",
                          "Passwords do not match",
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                    child: Text(
                      'Sign Up',
                      style: GoogleFonts.workSans(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    )),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account?',
                      style: GoogleFonts.workSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      )),
                  InkWell(
                    onTap: () {
                      Get.offNamed('/login');
                    },
                    child: Text(
                      '  Login',
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
