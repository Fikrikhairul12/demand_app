import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/manage_job_controller.dart';

class ManageJobView extends GetView<ManageJobController> {
  const ManageJobView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Job'),
        centerTitle: true,
      ),
      body: GetBuilder<ManageJobController>(
        builder: (controller) {
          final job = controller.job;
          final submission = controller.submissionData;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildAccordion(
                    title: "Job Details",
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Job Name: ${job.title}",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        Text("Description: ${job.description}"),
                        Text("Status: ${job.status}"),
                      ],
                    ),
                  ),
                  _buildAccordion(
                    title: "Freelance Submission",
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (submission != null && submission['notes'] != null)
                          Text("Notes: ${submission['notes']}"),
                        if (submission != null && submission['link'] != null)
                          ElevatedButton(
                            onPressed: () async {
                              final link = submission['link'] ?? '';
                              if (link.isNotEmpty) {
                                await Clipboard.setData(
                                    ClipboardData(text: link));
                                Get.snackbar("Success",
                                    "Link berhasil disalin ke clipboard!",
                                    snackPosition: SnackPosition.BOTTOM);
                              } else {
                                Get.snackbar("Error", "Link tidak tersedia!",
                                    snackPosition: SnackPosition.BOTTOM);
                              }
                            },
                            child: const Text("Salin Link"),
                          ),
                        const SizedBox(height: 16),
                        ...controller.applicants
                            .where((applicant) =>
                                applicant['status'] ==
                                'accepted') // Filter hanya accepted
                            .map((applicant) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      controller
                                          .revisionTask(applicant['docId']);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                    ),
                                    child: const Text("Revision"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      controller.approveTask();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                    ),
                                    child: const Text("Approve"),
                                  ),
                                ],
                              ),
                              const Divider(),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAccordion({required String title, required Widget content}) {
    return ExpansionTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      children: [Padding(padding: const EdgeInsets.all(8.0), child: content)],
    );
  }
}
