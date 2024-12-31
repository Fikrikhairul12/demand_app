import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/application_controller.dart';

class ApplicationView extends GetView<ApplicationController> {
  const ApplicationView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Details'),
        centerTitle: true,
      ),
      body: GetBuilder<ApplicationController>(
        builder: (controller) {
          final job = controller.selectedJob;
          final client = controller.clientData;

          if (job == null || client == null) {
            return const Center(child: CircularProgressIndicator());
          }

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
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("Description: ${job.description}"),
                        TextButton(
                          onPressed: () async {
                            final link = job.linkFile;
                            try {
                              if (link.isNotEmpty) {
                                await Clipboard.setData(
                                    ClipboardData(text: link));
                                Get.snackbar(
                                  "Success",
                                  "Link berhasil disalin ke clipboard!",
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              } else {
                                Get.snackbar(
                                  "Error",
                                  "Link tidak tersedia!",
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              }
                            } catch (e) {
                              print('Error : $e');
                            }
                          },
                          child: const Text("Salin Link"),
                        ),
                        Text("Status: ${job.status}"),
                      ],
                    ),
                  ),
                  _buildAccordion(
                    title: "Contact Client",
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Name: ${client['name'] ?? 'Unknown'}"),
                        Text("Phone: ${client['phone'] ?? 'Unknown'}"),
                        if (client['email'] != null)
                          Text("Email: ${client['email']}"),
                      ],
                    ),
                  ),
                  _buildAccordion(
                    title: "Submit Task",
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: controller.linkController,
                          decoration: const InputDecoration(
                            labelText: "Link to Work",
                          ),
                        ),
                        TextField(
                          controller: controller.notesController,
                          decoration: const InputDecoration(
                            labelText: "Notes (optional)",
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            controller.submitTask();
                          },
                          child: const Text("Submit Work"),
                        ),
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
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      children: [Padding(padding: const EdgeInsets.all(8.0), child: content)],
    );
  }
}
