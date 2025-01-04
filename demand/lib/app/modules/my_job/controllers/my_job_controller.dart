import 'package:demand/app/data/models/job_model.dart';
import 'package:demand/app/data/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class MyJobController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();
  final JobService _jobService = JobService();
  final RxList<Job> jobs = <Job>[].obs;
  final RxList<Job> appliedJobs = <Job>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool showAll = false.obs;
  final RxMap<String, String> jobUsernames = <String, String>{}.obs;
  final RxBool hasLicense = false.obs;
  final RxMap<String, String> jobLinks = <String, String>{}.obs;

  // Get current user ID
  String get currentUserId {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid ?? '';
  }

  @override
  void onInit() {
    super.onInit();
    fetchJobs();
    fetchAppliedJobs();
  }

  Future<void> fetchJobs() async {
    try {
      isLoading.value = true;

      final userId = currentUserId;

      hasLicense.value = await _firebaseService.fetchUserLicense(userId);
      final fetchedJobs = await _jobService.fetchJobsByUser(userId);
      jobs.assignAll(fetchedJobs);

      await Future.wait(fetchedJobs.map((job) async {
        final username = await _jobService.fetchUsername(job.userId);
        if (username != null) {
          jobUsernames[job.userId] = username;
        }

        // Cari dokumen ID berdasarkan status "finished"
        if (job.status == "finished") {
          final documentId = await _firebaseService.getJobDocumentId(job.title);
          if (documentId != null) {
            // Ambil data link dari submission
            final submissionData =
                await _firebaseService.getSubmissionDataByJobId(documentId);
            if (submissionData != null) {
              jobLinks[job.title] = submissionData['link'] ?? 'No link';
            }
          }
        }
      }));
    } catch (e) {
      Get.snackbar('Error', 'Failed to load jobs: $e');
      print('Failed to load jobs: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAppliedJobs() async {
    try {
      final userId = currentUserId;
      final applicationData = await _jobService.fetchApplicationsByUser(userId);

      if (applicationData.isEmpty) {
        appliedJobs.clear();
        return;
      }

      final appliedJobIds =
          applicationData.map((app) => app['jobId'] as String).toList();

      final fetchedJobs = await _jobService.fetchJobsByIds(appliedJobIds);
      appliedJobs.assignAll(fetchedJobs);

      await Future.wait(fetchedJobs.map((job) async {
        final username = await _jobService.fetchUsername(job.userId);
        if (username != null) {
          jobUsernames[job.userId] = username;
        }
      }));
    } catch (e) {
      Get.snackbar('Error', 'Failed to load applied jobs: $e');
      print('Failed to load applied jobs: $e');
    }
  }

  void toggleCardExpansion(int index) {
    jobs[index].isExpanded = !jobs[index].isExpanded;
    jobs.refresh();
  }

  bool isCardExpanded(int index) {
    return jobs[index].isExpanded;
  }

  void toggleShowAll() {
    showAll.value = !showAll.value;
  }

  void toggleJobExpansion(int index) {
    jobs[index].isExpanded = !jobs[index].isExpanded;
    jobs.refresh();
  }

  void toggleAppliedJobExpansion(int index) {
    appliedJobs[index].isExpanded = !appliedJobs[index].isExpanded;
    appliedJobs.refresh();
  }

  bool isJobExpanded(int index) {
    return jobs[index].isExpanded;
  }

  bool isAppliedJobExpanded(int index) {
    return appliedJobs[index].isExpanded;
  }
}
