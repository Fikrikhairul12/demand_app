import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 185, 224, 255),
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signOut();
                Get.offAllNamed(
                    '/login'); // Arahkan ke halaman login setelah logout
              } catch (e) {
                print('Error during logout: $e');
              }
            },
          ),
        ],
      ),
      body: GetX<HomeController>(
        init: HomeController(),
        builder: (controller) {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.jobs.isEmpty) {
            return const Center(child: Text('No jobs available.'));
          } else {
            return ListView.builder(
              itemCount: controller.jobs.length,
              itemBuilder: (context, index) {
                final job = controller.jobs[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(job.title,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                        'Created by: ${job.username}\nCreated on: ${job.createdAt}'),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
