import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget onboardingPage({
  required String title,
  required String description,
  required String imagePath,
}) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(imagePath, height: 200),
        SizedBox(height: 20),
        Text(
          title,
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        SizedBox(
          width: 355,
          child: Text(
            description,
            style: GoogleFonts.poppins(fontSize: 15),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
}
