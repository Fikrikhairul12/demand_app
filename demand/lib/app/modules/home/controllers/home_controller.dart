import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demand/app/data/models/home_model.dart';
import 'package:demand/app/data/services/firebase_service.dart';
import 'package:demand/app/modules/my_job/controllers/my_job_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var jobs = <HomeModel>[].obs;
  var isLoading = true.obs;

  // Mengambil daftar pekerjaan dan menyimpannya ke dalam list
  void fetchJobs() async {
    try {
      isLoading(true);
      List<HomeModel> fetchedJobs = await HomeService().fetchJobs();
      jobs.assignAll(fetchedJobs);
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading(false);
    }
  }

  void toggleCardExpansion(int index) {
    jobs[index].isExpanded = !jobs[index].isExpanded;
    jobs.refresh();
  }

  void applyForJob(String jobId, double offer) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      String userId = user.uid;

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (!userDoc.exists || !(userDoc['license'] ?? false)) {
        Get.defaultDialog(
          title: 'License Required',
          middleText:
              'You cannot apply for this job because you do not have a license.',
          textConfirm: 'OK',
          onConfirm: () => Get.back(),
        );
        return;
      }

      final jobDoc =
          await FirebaseFirestore.instance.collection('jobs').doc(jobId).get();

      if (!jobDoc.exists) return;

      if (jobDoc['status'] == 'applied') {
        Get.snackbar('Info', 'Job already applied by another user.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange,
            colorText: Colors.white);
        return;
      }

      String jobOwnerId = jobDoc['userId'] ?? '';
      if (userId == jobOwnerId) {
        Get.snackbar('Error', 'You cannot apply for your own job.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        return;
      }

      final applicationsRef =
          FirebaseFirestore.instance.collection('applications');
      final querySnapshot = await applicationsRef
          .where('userId', isEqualTo: userId)
          .where('jobId', isEqualTo: jobId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        Get.snackbar('Info', 'You have already applied for this job.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange,
            colorText: Colors.white);
        return;
      }

      await applicationsRef.add({
        'userId': userId,
        'jobId': jobId,
        'offer': offer,
        'status': 'pending',
        'apply_date': Timestamp.now(),
      });

      await FirebaseFirestore.instance.collection('notifications').add({
        'userId': jobOwnerId,
        'message': 'Job Anda telah dilamar oleh seorang freelancer.',
        'type': 'Job',
        'timestamp': Timestamp.now(),
      });

      final myJobController = Get.find<MyJobController>();
      await myJobController.fetchAppliedJobs();

      Get.snackbar('Success', 'You have successfully applied for this job.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
    } catch (e) {
      print("Error saat melamar: $e");
      Get.snackbar('Error', 'An error occurred while applying for the job.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchJobs();
  }

  void showOfferDialog(String jobId) {
    TextEditingController offerController = TextEditingController();

    Get.defaultDialog(
      title: 'Enter Your Offer',
      content: Column(
        children: [
          TextField(
            controller: offerController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: 'Enter your offer'),
          ),
        ],
      ),
      textConfirm: 'Submit',
      textCancel: 'Cancel',
      onConfirm: () {
        final offer = double.tryParse(offerController.text);
        if (offer != null) {
          Get.back(); // tutup dialog
          applyForJob(jobId, offer); // panggil applyForJob dengan offer
        } else {
          Get.snackbar(
            'Invalid input',
            'Please enter a valid number.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      },
    );
  }
}
