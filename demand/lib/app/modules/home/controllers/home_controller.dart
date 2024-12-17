import 'package:demand/app/data/models/home_model.dart';
import 'package:demand/app/data/services/firebase_service.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var jobs = <HomeModel>[].obs;
  var isLoading = true.obs;


  // Mengambil daftar pekerjaan dan menyimpannya ke dalam list
  void fetchJobs() async {
    try {
      isLoading(true);
      List<HomeModel> fetchedJobs = await HomeService().fetchJobs();
      jobs.assignAll(fetchedJobs);
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading(false);
    }
  }

  void toggleCardExpansion(int index) {
    jobs[index].isExpanded = !jobs[index].isExpanded;
    jobs.refresh();
  }

  @override
  void onInit() {
    super.onInit();
    fetchJobs();
  }
}
