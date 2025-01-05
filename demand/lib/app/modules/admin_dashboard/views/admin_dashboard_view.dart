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
    return DefaultTabController(
      length: 3, // Tab utama: Licenses dan Users
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff016FCB),
          title: Image.asset(
            'assets/icons/demandtext.png',
          ),
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
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'Licenses'),
              Tab(text: 'Users'),
              Tab(text: 'Jobs'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            //TODO Tab 1: Licenses
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.licenses.isEmpty) {
                return const Center(child: Text("No licenses found"));
              }

              return ListView.builder(
                itemCount: controller.licenses.length,
                itemBuilder: (context, index) {
                  var license = controller.licenses[index];
                  var user = controller.users[index];
                  return GestureDetector(
                    onTap: () => controller.toggleExpansion(index),
                    child: Card(
                      margin: const EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              license.fullName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text('Skill Category: ${license.skillCategory}'),
                            Text('Job Type: ${license.jobType}'),
                            Text('Status: ${license.status}'),
                            if (license.isExpanded) ...[
                              const Divider(),
                              Text('Gender: ${license.gender}'),
                              Text('Phone: ${license.phone}'),
                              Text('Email: ${license.email}'),
                              Text('Motivation: ${license.motivation}'),
                              const SizedBox(height: 10),
                              if (controller.shouldShowButtons(license.status))
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        controller.approveLicense(
                                          user.id,
                                          license.id,
                                        );
                                        print(
                                            "Agree pressed for ${license.id}");
                                      },
                                      child: const Text('Agree'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        print(
                                            "Disagree pressed for ${license.id}");
                                      },
                                      child: const Text('Disagree'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),

            //TODO Tab 2: Users
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.users.isEmpty) {
                return const Center(child: Text("No users found"));
              }

              return ListView.builder(
                itemCount: controller.users.length,
                itemBuilder: (context, index) {
                  var user = controller.users[index];
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.fullName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text('Email: ${user.email}'),
                          Text('Phone: ${user.phone}'),
                          Text('Role: ${user.role}'),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),

            //TODO Tab 3: Jobs
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.jobsList.isEmpty) {
                return const Center(child: Text("No jobs found"));
              }

              return ListView.builder(
                itemCount: controller.jobsList.length,
                itemBuilder: (context, index) {
                  final job = controller.jobsList[index];
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text('Description: ${job.description}'),
                          Text('Type: ${job.type}'),
                          Text('Status: ${job.status}'),
                          Text('Posted by: ${job.username}'),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
