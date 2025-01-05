import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demand/app/data/models/job_model.dart';
import 'package:demand/app/data/models/license_model.dart';
import 'package:demand/app/data/models/user_model.dart';
import 'package:demand/app/data/services/admin_service.dart';
import 'package:get/get.dart';

class AdminDashboardController extends GetxController {
  var licenses = <GetLicense>[].obs;
  var users = <UserModel>[].obs;
  var jobsList = <DataJob>[].obs;
  var isLoading = true.obs;

  // Mengambil data dari service
  @override
  void onInit() {
    fetchLicenses();
    fetchUsers();
    fetchJobs();
    super.onInit();
  }

  void fetchLicenses() async {
    isLoading(true);
    try {
      List<GetLicense> fetchedLicenses =
          await Get.find<LicenseService>().getAllLicenses();
      licenses.assignAll(fetchedLicenses);
    } finally {
      isLoading(false);
    }
  }

  void fetchUsers() async {
    isLoading(true);
    try {
      List<UserModel> fetchedUsers =
          await Get.find<LicenseService>().getAllUsers();
      users.assignAll(
          fetchedUsers); // Menyimpan data pengguna yang telah diperbarui
    } finally {
      isLoading(false);
    }
  }

  void fetchJobs() async {
    isLoading.value = true;
    try {
      final jobCollection =
          await FirebaseFirestore.instance.collection('jobs').get();
      List<DataJob> jobs = [];

      for (var jobDoc in jobCollection.docs) {
        final data = jobDoc.data();
        final userId = data['userId'] ?? '';

        // Fetch user data for username
        String username = 'Unknown'; // Default jika username tidak ditemukan
        if (userId.isNotEmpty) {
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get();
          if (userDoc.exists) {
            username = userDoc.data()?['username'] ?? 'Unknown';
          }
        }

        // Add job with fetched data including username
        jobs.add(DataJob.fromFirestore(data, jobDoc.id, username));
      }

      jobsList.assignAll(jobs);
    } catch (e) {
      print('Error fetching jobs: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void toggleExpansion(int index) {
    licenses[index].isExpanded = !licenses[index].isExpanded;
    licenses.refresh();
  }

  bool shouldShowButtons(String status) {
    return status == 'pending';
  }

  // Fungsi untuk menyetujui lisensi
  Future<void> approveLicense(String userId, String licenseId) async {
    await Get.find<LicenseService>().approveLicense(userId, licenseId);
    fetchLicenses(); // Perbarui data setelah perubahan
  }

  // Fungsi untuk menolak lisensi
  Future<void> rejectLicense(String userId, String licenseId) async {
    await Get.find<LicenseService>().rejectLicense(userId, licenseId);
    fetchLicenses(); // Perbarui data setelah perubahan
  }
}
