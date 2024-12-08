import 'package:demand/app/data/services/admin_service.dart';
import 'package:get/get.dart';

import '../controllers/admin_dashboard_controller.dart';

class AdminDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminDashboardController>(
      () => AdminDashboardController(),
    );
    Get.lazyPut<LicenseService>(() => LicenseService());
  }
}
