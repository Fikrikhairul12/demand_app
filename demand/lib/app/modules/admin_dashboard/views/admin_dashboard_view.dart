import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/admin_dashboard_controller.dart';

class AdminDashboardView extends GetView<AdminDashboardController> {
  const AdminDashboardView({super.key});
  @override
  Widget build(BuildContext context) {
    final AdminDashboardController controller =
        Get.put(AdminDashboardController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('AdminDashboardView'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signOut();
                Get.offAllNamed(
                    '/login');
              } catch (e) {
                print('Error during logout: $e');
              }
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.licenses.isEmpty) {
          return Center(child: Text("No licenses found"));
        }

        return ListView.builder(
          itemCount: controller.licenses.length,
          itemBuilder: (context, index) {
            var license = controller.licenses[index];
            return ListTile(
              title: Text(license.fullName),
              subtitle: Text('Skill Category: ${license.skillCategory}'),
              trailing: Text(license.jobType),
            );
          },
        );
      }),
    );
  }
}
