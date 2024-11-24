import 'package:get/get.dart';

import '../controllers/my_job_controller.dart';

class MyJobBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyJobController>(
      () => MyJobController(),
    );
  }
}
