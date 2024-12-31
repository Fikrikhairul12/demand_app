import 'package:demand/app/data/models/job_model.dart';
import 'package:demand/app/data/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ApplicationController extends GetxController {
  final ApplicationService _applicationService = ApplicationService();
  Job? selectedJob;
  Map<String, dynamic>? clientData;
  final TextEditingController linkController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  String? jobId;
  String? get userId {
    final User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  @override
  void onInit() async {
    super.onInit();

    if (Get.arguments is Job) {
      selectedJob = Get.arguments as Job;
      // print("Received Job: ${selectedJob?.title}");

      // Ambil Job ID berdasarkan title
      jobId = await _applicationService.getJobIdByTitle(selectedJob!.title);
      // print("Fetched Job ID: $jobId");

      if (jobId != null) {
        await _fetchJobDetails(jobId!); // Panggil fetch job details
      }
    } else {
      print("Invalid argument passed to ApplicationController");
    }
  }

  Future<void> _fetchJobDetails(String jobId) async {
    // print("Fetching Job Details for jobId: $jobId");
    selectedJob = await _applicationService.getJobById(jobId);

    if (selectedJob != null) {
      // print("Fetched Job: ${selectedJob.toString()}");
      clientData = await _applicationService.getUserById(selectedJob!.userId);
    } else {
      print("Job not found for jobId: $jobId");
    }

    update(); // Perbarui UI
  }

  Future<void> submitTask() async {
    if (jobId == null || userId == null) {
      Get.snackbar(
        "Error",
        "Job ID atau User ID tidak tersedia.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final link = linkController.text.trim();
    final notes = notesController.text.trim();

    if (link.isEmpty) {
      Get.snackbar(
        "Error",
        "Link tidak boleh kosong.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      // Simpan data ke koleksi `submission`
      final submissionData = {
        'jobId': jobId,
        'userId': userId,
        'link': link,
        'notes': notes,
        'timestamp': DateTime.now(),
      };

      await _applicationService.submitTaskToFirestore(submissionData);

      // Ubah status job menjadi `finished`
      await _applicationService.updateJobStatus(jobId!, "finished");

      // Tampilkan dialog berhasil
      Get.defaultDialog(
        title: "Success",
        middleText: "Tugas berhasil dikirim!",
        textConfirm: "OK",
        onConfirm: () async {
              Get.back();
              Get.back();
            },
      );
    } catch (e) {
      print("Error saat submit task: $e");
      Get.snackbar(
        "Error",
        "Gagal mengirim tugas. Coba lagi nanti.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
