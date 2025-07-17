import 'package:get/get.dart';

import '../controllers/manage_job_controller.dart';

class ManageJobBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ManageJobController>(
      () => ManageJobController(),
    );
  }
}
