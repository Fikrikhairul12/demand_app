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
                Get.offAllNamed('/login');
              } catch (e) {
                print('Error during logout: $e');
              }
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.licenses.isEmpty) {
          return const Center(child: Text("No licenses found"));
        }

        if (controller.users.isEmpty) {
          return const Center(child: Text("No users found"));
        }

        return ListView.builder(
          itemCount: controller.licenses.length,
          itemBuilder: (context, index) {
            var license = controller.licenses[index];
            if (index < controller.users.length) {
              var user = controller.users[index];
              return GestureDetector(
                onTap: () => controller.toggleExpansion(index),
                child: Card(
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          license.fullName,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text('Skill Category: ${license.skillCategory}'),
                        Text('Job Type: ${license.jobType}'),
                        Text('Status: ${license.status}'),
                        if (license.isExpanded) ...[
                          Divider(),
                          Text('Gender: ${license.gender}'),
                          Text('Phone: ${license.phone}'),
                          Text('Email: ${license.email}'),
                          Text('Motivation: ${license.motivation}'),
                          SizedBox(height: 10),
                          if (controller.shouldShowButtons(license.status)) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    controller.approveLicense(
                                      user.id,
                                      license.id,
                                    );
                                    print("Agree pressed for ${license.id}");
                                    print("User ID: ${user.id}");
                                  },
                                  child: Text('Agree'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    print("Disagree pressed for ${license.id}");
                                  },
                                  child: Text('Disagree'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return const Center(child: Text("User data mismatch"));
            }
          },
        );
      }),
    );
  }
}
