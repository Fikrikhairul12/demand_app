import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/splashscreen_controller.dart';

class SplashscreenView extends GetView<SplashscreenController> {
  const SplashscreenView({super.key});
  @override
  Widget build(BuildContext context) {
    final SplashscreenController controller =
        Get.find<SplashscreenController>();
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 185, 224, 255),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 300,
                height: 300,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/demand_png.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "DEMAND.ID",
                style: GoogleFonts.poppins(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
