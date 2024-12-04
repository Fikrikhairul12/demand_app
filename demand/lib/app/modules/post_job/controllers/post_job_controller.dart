import 'package:demand/app/data/models/job_model.dart';
import 'package:demand/app/data/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostJobController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();

  String? get userId {
    final User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  final RxInt currentStep = 0.obs;

  final RxBool isNextEnabled = false.obs;

  String title = '';
  String description = '';
  var selectedCategory = ''.obs;
  var jobType = ''.obs;
  String linkFile = '';
  int price = 0;
  String paymentMethod = '';
  final virtualAccount = ''.obs;
  bool isPayment = false;

  Future<void> completePayment() async {
    if (!isPayment) {
      Get.defaultDialog(
          title: "Payment",
          middleText: "Please complete the payment first",
          textConfirm: "OK",
          onConfirm: () {
            isPayment = true;
            Get.back();
          });
    } else {
      await submitJob();
    }
  }

  final List<String> jobCategories = [
    'IT & Software',
    'Design & Creative',
    'Writing & Translation',
    'Marketing & Sales',
    'Admin & Support',
  ];

  void validateStep1() {
    if (title.isNotEmpty &&
        description.isNotEmpty &&
        selectedCategory.value.isNotEmpty &&
        jobType.value.isNotEmpty) {
      isNextEnabled.value = true;
    } else {
      isNextEnabled.value = false;
    }
  }

  void validateStep2() {
    if (linkFile.isNotEmpty) {
      isNextEnabled.value = true;
    } else {
      isNextEnabled.value = false;
    }
  }

  Future<void> submitJob() async {
    if (!validateStep3()) return;

    final userId = this.userId;
    if (userId == null) {
      Get.snackbar(
        'Error',
        'User is not logged in.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final job = JobModel(
      userId: userId,
      title: title,
      description: description,
      category: selectedCategory.value,
      jobType: jobType.value,
      price: price,
      linkFile: linkFile,
      paymentMethod: paymentMethod,
      virtualAccount: jobType.value == 'Online' ? virtualAccount.value : null,
      isPayment: isPayment,
      createdAt: DateTime.now(),
    );

    await _firebaseService.createJob(job.toMap());

    Get.offAllNamed('/main-navigation');

    Get.snackbar(
      'Success',
      'Job successfully created!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  List<String> getPaymentMethods() {
    if (jobType.value == 'Online') {
      return ['BNI', 'BCA', 'BRI', 'Bank Mandiri', 'BTN'];
    } else {
      return ['BNI', 'BCA', 'BRI', 'Bank Mandiri', 'BTN', 'Tunai'];
    }
  }

  void generateVirtualAccount() {
    if (jobType.value == 'Online') {
      virtualAccount.value = 'VA${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  bool validateStep3() {
    if (price > 0 && paymentMethod.isNotEmpty) {
      return true;
    } else {
      Get.snackbar(
        'Validation Error',
        'Please fill in all fields before proceeding.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }
}
