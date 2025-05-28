import 'package:demand/app/data/models/job_model.dart';
import 'package:demand/app/data/services/firebase_service.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PaymentController extends GetxController {
  late Job job;
  final FirebaseService _firebaseService = FirebaseService();
  var applicants = <Map<String, dynamic>>[].obs;
  var selectedImage = Rx<XFile?>(null);

  @override
  void onInit() {
    super.onInit();
    job = Get.arguments;
    _offerpayment();
  }

  void _offerpayment() async {
    final jobId = await _firebaseService.getJobDocumentId(job.title);
    if (jobId != null) {
      final applications =
          await _firebaseService.fetchApplicationsByJobIdWithDocId(jobId);

      final List<Map<String, dynamic>> result = [];

      for (var app in applications) {
        final status = app['data']['status'];
        if (status == 'accepted') {
          final userId = app['data']['userId'];
          final userData = await _firebaseService.fetchUserData(userId);

          if (userData != null) {
            result.add({
              'docId': app['docId'],
              'username': userData['username'] ?? 'Unknown',
              'profilePicture': userData['profilePicture'],
              'offerPrice': app['data']['offer'],
              'status': status,
            });
          }
        }
      }

      applicants.assignAll(result);
    } else {
      print("❌ Job ID tidak ditemukan untuk title: ${job.title}");
    }
  }

  Future<void> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        selectedImage.value = image;
        print("✅ Gambar berhasil dipilih: ${image.path}");
      } else {
        print("ℹ️ Pengguna membatalkan pemilihan gambar.");
      }
    } catch (e) {
      print("❌ Gagal memilih gambar: $e");
    }
  }
}
