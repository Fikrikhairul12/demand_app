import 'package:demand/app/modules/home/views/home_view.dart';
import 'package:demand/app/modules/my_job/views/my_job_view.dart';
import 'package:demand/app/modules/notification/views/notification_view.dart';
import 'package:demand/app/modules/profile/views/profile_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/main_navigation_controller.dart';

class MainNavigationView extends GetView<MainNavigationController> {
  MainNavigationView({super.key});

  final List<Widget> pages = [
    const HomeView(),
    const MyJobView(),
    const NotificationView(),
    const ProfileView(),
  ];
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: pages.isNotEmpty && controller.currentIndex.value < pages.length
            ? pages[controller.currentIndex.value]
            : Center(child: CircularProgressIndicator()),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          currentIndex: controller.currentIndex.value,
          onTap: (index) => controller.changePage(index), // Gunakan function
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Beranda',
              backgroundColor: Color(0xff016FCB),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment),
              label: 'Pekerjaan Saya',
              backgroundColor: Color(0xff016FCB),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notifikasi',
              backgroundColor: Color(0xff016FCB),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Akun',
              backgroundColor: Color(0xff016FCB),
            ),
          ],
        ),
      ),
    );
  }
}
