import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

        return RefreshIndicator(
          onRefresh: () async {
            await controller.fetchJobs();
            await controller.fetchAppliedJobs();
          },
          child: controller.jobs.isEmpty
              ? ListView(
                  // Agar bisa ditarik walau kosong
                  children: const [
                    SizedBox(height: 200),
                    Center(child: Text("Kamu belum membuat job!")),
                  ],
                )
              : SingleChildScrollView(
                  physics:
                      const AlwaysScrollableScrollPhysics(), // Penting agar tetap bisa ditarik
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //TODO: history job
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          "History Job",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.jobs.length,
                        itemBuilder: (context, index) {
                          final job = controller.jobs[index];
                          final username =
                              controller.jobUsernames[job.userId] ??
                                  "Unknown User";

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
                                    if (controller.isCardExpanded(index))
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Deskripsi: ${job.description}"),
                                          Text("Harga: Rp${job.price}"),
                                          if (job.status == 'pending')
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  // output log docId
                                                  Get.toNamed('/applicant',
                                                      arguments: job);
                                                },
                                                child: const Text(
                                                    "View Applicants"),
                                              ),
                                            ),
                                          if (job.status == 'waiting')
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  // output log docId
                                                  Get.toNamed('/payment',
                                                      arguments: job);
                                                },
                                                child: const Text("Pembayaran"),
                                              ),
                                            ),
                                          if (job.status == "finished" &&
                                              controller.jobLinks
                                                  .containsKey(job.title))
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    "Notes: ${controller.jobNotes[job.title]}"),
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    final link =
                                                        controller.jobLinks[
                                                                job.title] ??
                                                            '';
                                                    final notes =
                                                        controller.jobNotes[
                                                                job.title] ??
                                                            '';
                                                    if (link.isEmpty ||
                                                        notes.isEmpty) {
                                                      Get.snackbar("Error",
                                                          "Data job belum lengkap!");
                                                    } else {
                                                      Get.toNamed('/manage-job',
                                                          arguments: job);
                                                    }
                                                  },
                                                  child:
                                                      const Text("Manage Job"),
                                                ),
                                              ],
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
                      //TODO: Bagian Lamar Job
                      if (controller.hasLicense.value) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16),
                          child: Text(
                            "History Lamar Job",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
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
                          Obx(() {
                            final filteredJobs = controller.appliedJobs
                                .where((job) =>
                                    job.status == 'ongoing' ||
                                    job.status == 'finished')
                                .toList();

                            if (filteredJobs.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  "Belum ada history job yang sedang atau telah selesai.",
                                  style: TextStyle(fontSize: 16),
                                ),
                              );
                            }

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: filteredJobs.length,
                              itemBuilder: (context, index) {
                                final job = filteredJobs[index];
                                final username =
                                    controller.jobUsernames[job.userId] ??
                                        "Unknown User";

                                return GestureDetector(
                                  onTap: () => controller
                                      .toggleAppliedJobExpansion(index),
                                  child: Card(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                Text(
                                                    "Kategori: ${job.category}"),
                                                Text("Tipe: ${job.jobType}"),
                                                Text(
                                                    "Dibuat: ${job.createdAt}"),
                                              ],
                                            ),
                                          ),
                                          if (controller
                                              .isAppliedJobExpanded(index))
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    "Deskripsi: ${job.description}"),
                                                Text("Harga: Rp${job.price}"),
                                                const SizedBox(height: 10),
                                                Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: ElevatedButton(
                                                    onPressed: job.status ==
                                                            'finished'
                                                        ? null
                                                        : () {
                                                            Get.toNamed(
                                                                '/application',
                                                                arguments: job);
                                                          },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          job.status ==
                                                                  'finished'
                                                              ? Colors.grey
                                                              : Colors.blue,
                                                    ),
                                                    child: Text(
                                                      job.status == 'finished'
                                                          ? 'Selesai'
                                                          : 'Kerjakan',
                                                    ),
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
                            );
                          }),
                      ],
                    ],
                  ),
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
