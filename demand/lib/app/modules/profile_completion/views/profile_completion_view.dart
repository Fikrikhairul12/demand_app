import 'package:demand/app/widgets/profile_completion_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_completion_controller.dart';

class ProfileCompletionView extends GetView<ProfileCompletionController> {
  const ProfileCompletionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 185, 224, 255),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              Text(
                "Profile Info",
                style: GoogleFonts.poppins(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              CustomFormField(
                hintText: "Enter your username",
                labelText: "Username",
                controller: controller.usernameController,
              ),
              const SizedBox(height: 16),
              CustomFormField(
                hintText: "Enter your first name",
                labelText: "First Name",
                controller: controller.firstNameController,
              ),
              const SizedBox(height: 16),
              CustomFormField(
                hintText: "Enter your last name",
                labelText: "Last Name",
                controller: controller.lastNameController,
              ),
              const SizedBox(height: 16),
              IntlPhoneField(
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                initialCountryCode: 'ID',
                onChanged: (phone) {
                  controller.phoneController.text = phone.completeNumber;
                },
              ),
              const SizedBox(height: 16),
              CustomFormField(
                hintText: "Tell us about yourself",
                labelText: "Bio",
                controller: controller.bioController,
              ),
              const SizedBox(height: 32),
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
                  onPressed: controller.submitProfile,
                  child: Text(
                    "Submit",
                    style: GoogleFonts.workSans(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
