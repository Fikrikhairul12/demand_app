import 'package:demand/app/data/models/profile_model.dart';
import 'package:demand/app/data/services/profile_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final ProfileService _profileService = ProfileService();

  Rx<Profile?> profile = Rx<Profile?>(null);
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        profile.value = await _profileService.fetchCurrentUserProfile(userId);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
