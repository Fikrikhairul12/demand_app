import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/my_job_controller.dart';

class MyJobView extends GetView<MyJobController> {
  const MyJobView({super.key});
  @override
  Widget build(BuildContext context) {
    controller.fetchJobs();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pekerjaan Saya'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.jobs.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Kamu belum membuat job!"),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.jobs.length,
          itemBuilder: (context, index) {
            final job = controller.jobs[index];
            final username =
                controller.jobUsernames[job.userId] ?? "Unknown User";

            return GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (_) => Container(
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Judul: ${job.title}",
                              style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 8),
                          Text("Dibuat oleh: $username"),
                          const SizedBox(height: 8),
                          Text("Deskripsi: ${job.description}"),
                          const SizedBox(height: 8),
                          Text("Kategori: ${job.category}"),
                          const SizedBox(height: 8),
                          Text("Tipe Pekerjaan: ${job.jobType}"),
                          const SizedBox(height: 8),
                          Text("Harga: Rp ${job.price}"),
                          const SizedBox(height: 8),
                          Text("Metode Pembayaran: ${job.paymentMethod}"),
                          if (job.virtualAccount != null)
                            Text("Virtual Account: ${job.virtualAccount}"),
                          const SizedBox(height: 8),
                          Text("Dibuat: ${job.createdAt}"),
                        ],
                      ),
                    ),
                  ),
                );
              },
              child: Card(
                child: ListTile(
                  title: Text(job.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Dibuat oleh: $username"),
                      Text("Kategori: ${job.category}"),
                      Text("Tipe: ${job.jobType}"),
                      Text("Dibuat: ${job.createdAt}"),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30, right: 30),
        child: FloatingActionButton(
          onPressed: () {
            Get.toNamed('/post-job');
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  String formatDate(DateTime date) {
    final months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "Mei",
      "Jun",
      "Jul",
      "Agu",
      "Sep",
      "Okt",
      "Nov",
      "Des"
    ];
    return "${date.hour}:${date.minute.toString().padLeft(2, '0')} ${date.day} ${months[date.month - 1]} ${date.year}";
  }
}
