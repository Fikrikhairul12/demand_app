import 'package:demand/app/data/models/job_model.dart';
import 'package:demand/app/data/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ApplicantController extends GetxController {
  late Job job;
  final FirebaseService _firebaseService = FirebaseService();
  var applicants = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    job = Get.arguments;

    _fetchApplicantsWithUserData();
  }

  void _fetchApplicantsWithUserData() async {
    final jobId = await _firebaseService.getJobDocumentId(job.title);
    if (jobId != null) {
      final applications =
          await _firebaseService.fetchApplicationsByJobIdWithDocId(jobId);

      final List<Map<String, dynamic>> result = [];

      for (var app in applications) {
        final userId = app['data']['userId'];
        final userData = await _firebaseService.fetchUserData(userId);

        if (userData != null) {
          result.add({
            'docId': app['docId'],
            'username': userData['username'] ?? 'Unknown',
            'profilePicture': userData['profilePicture'] ?? null,
            'offerPrice': app['data']['offer'],
            'status': app['data']['status'],
          });
        }
      }
      applicants.assignAll(result);
    } else {
      print("❌ Job ID tidak ditemukan untuk title: ${job.title}");
    }
  }

  void updateApplication(String applicationId) async {
    print("🔁 Proses update aplikasi...");

    try {
      // Ambil detail aplikasi dari docId
      final applicationDoc =
          await _firebaseService.getApplicationById(applicationId);
      if (applicationDoc == null) {
        print("❌ Aplikasi dengan ID $applicationId tidak ditemukan");
        return;
      }

      final userId = applicationDoc['userId'];
      final now = DateTime.now();

      final currentUser = FirebaseAuth.instance.currentUser;
      final currentUserId = currentUser?.uid;

      final currentUserData =
          await _firebaseService.fetchUserData('$currentUserId');
      final currentUsername = currentUserData?['username'] ?? 'Pengguna';

      // 1. Update field status dan selectedAt di koleksi applications
      await _firebaseService.updateApplicationStatus(
        docId: applicationId,
        data: {
          'status': 'selected',
          'selectedAt': now,
        },
      );

      // 2. Tambahkan notifikasi ke koleksi notifications
      await _firebaseService.addNotification({
        'message': '$currentUsername menyetujui tawaran anda "${job.title}"',
        'userId': userId,
        'timestamp': now,
        'type': 'Accepted',
        'appId': applicationId,
        'status': 'pending',
      });

      
      print("✅ Aplikasi berhasil diupdate dan notifikasi dikirim!");
    } catch (e) {
      print("❌ Gagal update aplikasi: $e");
    }
  }
}
