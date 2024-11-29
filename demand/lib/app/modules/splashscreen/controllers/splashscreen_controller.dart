import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SplashscreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    Future.delayed(Duration(seconds: 3), () {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        const adminEmails = ["11220318@nusamandiri.ac.id"];
        // Jika pengguna sudah login, arahkan ke halaman Home
        if (adminEmails.contains(user.email)) {
          // Arahkan ke Admin Dashboard
          Get.offAllNamed('/admin-dashboard');
        } else {
          // Arahkan ke Home untuk user biasa
          Get.offAllNamed('/main-navigation');
        }
      } else {
        // Jika belum login, arahkan ke halaman Login
        Get.offNamed('/onboarding');
      }
    });
  }
}
