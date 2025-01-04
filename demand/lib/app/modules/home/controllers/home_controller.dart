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

  void applyForJob(String jobId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("User not logged in.");
        return;
      }
      String userId = user.uid;

      // Cek lisensi user
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
          onConfirm: () {
            Get.back();
          },
        );
        return;
      }

      // Ambil data job
      final jobDoc =
          await FirebaseFirestore.instance.collection('jobs').doc(jobId).get();

      if (!jobDoc.exists) {
        print("Job tidak ditemukan.");
        return;
      }

      // Cek status job
      if (jobDoc['status'] == 'applied') {
        Get.snackbar(
          'Info',
          'Job already applied by another user.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      // Cek apakah user melamar job milik sendiri
      String jobOwnerId = jobDoc['userId'] ?? '';

      if (userId == jobOwnerId) {
        Get.snackbar(
          'Error',
          'You cannot apply for your own job.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Cek apakah user sudah melamar job ini
      final applicationsRef =
          FirebaseFirestore.instance.collection('applications');
      final querySnapshot = await applicationsRef
          .where('userId', isEqualTo: userId)
          .where('jobId', isEqualTo: jobId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        Get.snackbar(
          'Info',
          'You have already applied for this job.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      // Update status job ke 'applied'
      await FirebaseFirestore.instance.collection('jobs').doc(jobId).update({
        'status': 'applied',
      });

      // Tambahkan aplikasi ke collection 'applications'
      await applicationsRef.add({
        'userId': userId,
        'jobId': jobId,
        'apply_date': Timestamp.now(),
      });

      // Kirim notifikasi ke pemilik job
      await FirebaseFirestore.instance.collection('notifications').add({
        'userId': jobOwnerId, // Pemilik job
        'message': 'Job Anda telah dilamar oleh seorang freelancer.',
        'type': 'Job',
        'timestamp': Timestamp.now(),
      });

      // Update data di controller
      final myJobController = Get.find<MyJobController>();
      await myJobController.fetchAppliedJobs();

      Get.snackbar(
        'Success',
        'You have successfully applied for this job.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print("Error saat melamar: $e");
      Get.snackbar(
        'Error',
        'An error occurred while applying for the job.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchJobs();
  }
}
