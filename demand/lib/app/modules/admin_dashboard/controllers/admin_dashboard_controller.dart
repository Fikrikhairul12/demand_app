import 'package:demand/app/data/models/license_model.dart';
import 'package:demand/app/data/services/admin_service.dart';
import 'package:get/get.dart';

class AdminDashboardController extends GetxController {
  var licenses = <GetLicense>[].obs;
  var isLoading = true.obs;

  // Mengambil data dari service
  @override
  void onInit() {
    fetchLicenses();
    super.onInit();
  }

  void fetchLicenses() async {
    isLoading(true);
    try {
      List<GetLicense> fetchedLicenses = await Get.find<LicenseService>().getAllLicenses();
      licenses.assignAll(fetchedLicenses);
    } finally {
      isLoading(false);
    }
  }
}
