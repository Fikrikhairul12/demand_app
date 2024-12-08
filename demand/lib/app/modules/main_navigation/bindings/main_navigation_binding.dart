import 'package:demand/app/modules/home/bindings/home_binding.dart';
import 'package:demand/app/modules/my_job/bindings/my_job_binding.dart';
import 'package:demand/app/modules/notification/bindings/notification_binding.dart';
import 'package:demand/app/modules/profile/bindings/profile_binding.dart';
import 'package:get/get.dart';

import '../controllers/main_navigation_controller.dart';

class MainNavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainNavigationController>(
      () => MainNavigationController(),
    );
    HomeBinding().dependencies(); // Home
    MyJobBinding().dependencies(); // My Job
    NotificationBinding().dependencies(); // Notification
    ProfileBinding().dependencies(); // Profile
  }
}
