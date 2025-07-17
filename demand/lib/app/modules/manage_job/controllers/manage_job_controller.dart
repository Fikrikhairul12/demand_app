import 'package:demand/app/data/models/job_model.dart';
import 'package:demand/app/data/services/firebase_service.dart';
import 'package:get/get.dart';

class ManageJobController extends GetxController {
  late Job job;
  final FirebaseService _firebaseService = FirebaseService();
  final ApplicationService _applicationService = ApplicationService();
  Map<String, dynamic>? submissionData;
  var applicants = <Map<String, dynamic>>[].obs;

  void onInit() {
    super.onInit();
    job = Get.arguments;
    fetchSubmissionData();
  }

  Future<void> fetchSubmissionData() async {
    try {
      final jobId = await _firebaseService.getJobDocumentId(job.title);
      final data = await _firebaseService.getSubmissionDataByJobId(jobId!);
      if (data != null) {
        submissionData = {
          'link': data['link'] ?? '',
          'notes': data['notes'] ?? '',
        };
      } else {
        submissionData = null;
      }
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
              'userId': userId,
              'jobId' : jobId,
              'status': app['data']['status'],
            });
          }
        }
        applicants.assignAll(result);
      } else {
        print("❌ Job ID tidak ditemukan untuk title: ${job.title}");
      }
      update(); // Update GetBuilder UI
    } catch (e) {
      print('❌ Error fetching submission data: $e');
      submissionData = null;
    }
  }

  void revisionTask(applicationId) {
    print('Revisi untuk applicant dengan docId: $applicationId');
  }

  void approveTask() {
    print('Implementasi logic approve');
  }
}

