import 'package:demand/app/data/models/job_model.dart';
import 'package:demand/app/data/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class MyJobController extends GetxController {
  final JobService _jobService = JobService();
  final RxList<Job> jobs = <Job>[].obs;
  final RxBool isLoading = true.obs;

  // Mapping jobId to username
  final RxMap<String, String> jobUsernames = <String, String>{}.obs;

  // Get current user ID
  String get currentUserId {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid ?? '';
  }

  Future<void> fetchJobs() async {
    try {
      isLoading.value = true;
      final userId = currentUserId;
      final fetchedJobs = await _jobService.fetchJobsByUser(userId);
      jobs.assignAll(fetchedJobs);

      for (var job in fetchedJobs) {
        final username = await _jobService.fetchUsername(job.userId);
        if (username != null) {
          jobUsernames[job.userId] = username;
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load jobs: $e');
      print('Failed to load jobs: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
