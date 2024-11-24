import 'package:get/get.dart';

import '../controllers/license_application_controller.dart';

class LicenseApplicationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LicenseApplicationController>(
      () => LicenseApplicationController(),
    );
  }
}
