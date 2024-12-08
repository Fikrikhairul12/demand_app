import 'package:get/get.dart';

class MainNavigationController extends GetxController {
  var currentIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index; // Mengubah currentIndex
  }
}
