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

                return GestureDetector(
                  onTap: () => controller.toggleCardExpansion(index),
                  child: Card(
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            job.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Created by: ${job.username}\nCreated on: ${job.createdAt}',
                          ),
                        ),
                        if (job.isExpanded)
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Description: ${job.description.isNotEmpty ? job.description : 'No description available'}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Price: Rp${job.price}', // Format harga
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      controller.applyForJob(job
                                          .id); // Kirim job ID ke fungsi apply
                                    },
                                    child: const Text('Apply'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
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
