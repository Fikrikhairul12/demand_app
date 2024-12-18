import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demand/app/data/models/home_model.dart';
import 'package:demand/app/data/services/firebase_service.dart';
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
      // Ambil User ID dari Firebase Authentication
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("User not logged in.");
        return;
      }
      String userId = user.uid;

      // Cek apakah user memiliki lisensi
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (!userDoc.exists || !(userDoc['license'] ?? false)) {
        // Jika user tidak memiliki lisensi, tampilkan dialog
        Get.defaultDialog(
          title: 'License Required',
          middleText: 'You cannot apply for this job because you do not have a license.',
          textConfirm: 'OK',
          onConfirm: () {
            Get.back();
          },
        );
        return;
      }

      // Ambil data pekerjaan berdasarkan jobId
      final jobDoc =
          await FirebaseFirestore.instance.collection('jobs').doc(jobId).get();

      if (!jobDoc.exists) {
        print("Job tidak ditemukan.");
        return;
      }

      String jobOwnerId = jobDoc['userId'] ?? '';

      // Cek apakah user mencoba melamar jobnya sendiri
      if (userId == jobOwnerId) {
        Get.snackbar(
          'Error',
          'You cannot apply for your own job.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        print("Tidak bisa melamar job buatan sendiri.");
        return;
      }

      // Cek apakah sudah melamar job yang sama
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
        print("User sudah melamar job ini.");
        return;
      }

      // Simpan data apply ke koleksi 'applications'
      await applicationsRef.add({
        'userId': userId,
        'jobId': jobId,
        'apply_date': Timestamp.now(),
      });

      Get.snackbar(
        'Success',
        'You have successfully applied for this job.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      print("Apply berhasil!");
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
