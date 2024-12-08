import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demand/app/data/models/license_model.dart';
import 'package:demand/app/data/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class LicenseApplicationController extends GetxController {
  final RxInt currentStep = 0.obs;

  // Fields
  RxString fullName = ''.obs;
  RxString ktpNumber = ''.obs;
  RxString dateOfBirth = ''.obs;
  RxString gender = ''.obs;
  RxString email = ''.obs;
  RxString phone = ''.obs;
  RxString accountNumber = ''.obs;
  RxString bankName = ''.obs;
  RxString skillCategory = ''.obs;
  RxString jobType = ''.obs; // Store selected job type
  RxString motivation = ''.obs;
  RxBool isDeclarationChecked = false.obs;
  RxBool isPolicyChecked = false.obs;

  // Validate Step 1
  bool get isStep1Valid =>
      fullName.value.isNotEmpty &&
      ktpNumber.value.isNotEmpty &&
      gender.value.isNotEmpty &&
      email.value.isNotEmpty &&
      phone.value.isNotEmpty;

  // Validate Step 2
  bool get isStep2Valid =>
      accountNumber.value.isNotEmpty && bankName.value.isNotEmpty;

  // Validate Step 3
  bool get isStep3Valid =>
      skillCategory.value.isNotEmpty &&
      jobType.value.isNotEmpty &&
      motivation.value.isNotEmpty &&
      isDeclarationChecked.value &&
      isPolicyChecked.value;

  void validateStep1() {
    if (isStep1Valid) {
      // Additional validations if needed
    }
  }

  void validateStep2() {
    if (isStep2Valid) {
      // Additional validations if needed
    }
  }

  // Handle Stepper Navigation
  void handleContinue() async {
    if (currentStep.value == 0 && isStep1Valid) {
      currentStep.value++;
    } else if (currentStep.value == 1 && isStep2Valid) {
      currentStep.value++;
    } else if (currentStep.value == 2) {
      // Step 3 or final submission logic
      Get.defaultDialog(
        title: 'Confirmation',
        middleText: 'Are you sure you want to submit the application?',
        onConfirm: () async {
          submitApplication();
          Get.back();
          await Get.defaultDialog(
            title: 'Success',
            middleText: 'Application submitted successfully',
            textConfirm: 'OK',
            onConfirm: () async {
              Get.back();
              Get.back();
            },
          );
        },
        onCancel: () {
          Get.back();
        },
      );
    } else {
      print('Please complete the current step properly');
    }
  }

  void handleCancel() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  // Fetch user data from Firestore
  Future<void> fetchUserData() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final userDoc =
            FirebaseFirestore.instance.collection('users').doc(currentUser.uid);
        final snapshot = await userDoc.get();

        if (snapshot.exists) {
          final data = snapshot.data();
          fullName.value = data?['name'] ?? '';
          email.value = data?['email'] ?? '';
          phone.value = data?['phone'] ?? '';
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> submitApplication() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      final application = LicenseApplicationModel(
        fullName: fullName.value,
        ktpNumber: ktpNumber.value,
        dateOfBirth: dateOfBirth.value,
        gender: gender.value,
        email: email.value,
        phone: phone.value,
        accountNumber: accountNumber.value,
        bankName: bankName.value,
        skillCategory: skillCategory.value,
        jobType: jobType.value,
        motivation: motivation.value,
      );

      try {
        await LicenseApplicationService.submitLicenseApplication(
          currentUser.uid,
          application,
        );
        print('Application submitted successfully!');
      } catch (e) {
        print('Error submitting application: $e');
      }
    } else {
      print('No user is logged in.');
    }
  }

  @override
  void onInit() {
    fetchUserData(); // Fetch data when controller is initialized
    super.onInit();
  }
}
