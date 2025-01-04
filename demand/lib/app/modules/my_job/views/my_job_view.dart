import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/my_job_controller.dart';

class MyJobView extends GetView<MyJobController> {
  const MyJobView({super.key});
  @override
  Widget build(BuildContext context) {
    controller.fetchJobs();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 185, 224, 255),
      appBar: AppBar(
        backgroundColor: const Color(0xff016FCB),
        title: Image.asset(
          'assets/icons/demandtext.png',
        ),
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

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "History Job",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.jobs.length,
                itemBuilder: (context, index) {
                  final job = controller.jobs[index];
                  final username =
                      controller.jobUsernames[job.userId] ?? "Unknown User";

                  return GestureDetector(
                    onTap: () => controller.toggleJobExpansion(index),
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                job.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
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
                            if (controller.isCardExpanded(index))
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Deskripsi: ${job.description}"),
                                  Text("Harga: Rp${job.price}"),
                                  Text(
                                      "Metode Pembayaran: ${job.paymentMethod}"),
                                  if (job.virtualAccount != null)
                                    Text(
                                        "Virtual Account: ${job.virtualAccount}"),
                                  if (job.status == "finished" &&
                                      controller.jobLinks
                                          .containsKey(job.title))
                                    ElevatedButton(
                                      onPressed: () {
                                        final link =
                                            controller.jobLinks[job.title];
                                        print("Link: $link");
                                      },
                                      child: Text("Link Tugas"),
                                    ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              if (controller.hasLicense.value) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Text(
                    "History Lamar Job",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (controller.appliedJobs.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Kamu belum melamar job!",
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                else
                  Obx(() => ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.appliedJobs.length,
                        itemBuilder: (context, index) {
                          final job = controller.appliedJobs[index];
                          final username =
                              controller.jobUsernames[job.userId] ??
                                  "Unknown User";

                          return GestureDetector(
                            onTap: () =>
                                controller.toggleAppliedJobExpansion(index),
                            child: Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(
                                        job.title,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Dibuat oleh: $username"),
                                          Text("Kategori: ${job.category}"),
                                          Text("Tipe: ${job.jobType}"),
                                          Text("Dibuat: ${job.createdAt}"),
                                        ],
                                      ),
                                    ),
                                    if (controller.isAppliedJobExpanded(index))
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Deskripsi: ${job.description}"),
                                          Text("Harga: Rp${job.price}"),
                                          Text(
                                              "Metode Pembayaran: ${job.paymentMethod}"),
                                          if (job.virtualAccount != null)
                                            Text(
                                                "Virtual Account: ${job.virtualAccount}"),
                                          const SizedBox(height: 10),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: ElevatedButton(
                                              onPressed:
                                                  job.status == 'finished'
                                                      ? null
                                                      : () {
                                                          Get.toNamed(
                                                              '/application',
                                                              arguments: job);
                                                        },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    job.status == 'finished'
                                                        ? Colors.grey
                                                        : Colors.blue,
                                              ),
                                              child: Text(
                                                  job.status == 'finished'
                                                      ? 'Selesai'
                                                      : 'Kerjakan'),
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )),
              ],
            ],
          ),
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
}
