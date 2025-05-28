import 'package:demand/app/data/models/job_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/applicant_controller.dart';

class ApplicantView extends GetView<ApplicantController> {
  const ApplicantView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Applicant Offer'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${controller.job.title}",
              style:
                  GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            Obx(() {
              if (controller.applicants.isEmpty) {
                return const Text("Belum ada pelamar.");
              }

              return ListView.builder(
                shrinkWrap: true,
                itemCount: controller.applicants.length,
                itemBuilder: (context, index) {
                  final applicant = controller.applicants[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              applicant['profilePicture'] != null
                                  ? CircleAvatar(
                                      radius: 28,
                                      backgroundImage: NetworkImage(
                                          applicant['profilePicture']),
                                    )
                                  : const CircleAvatar(
                                      radius: 28,
                                      child: Icon(Icons.person),
                                    ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      applicant['username'],
                                      style: GoogleFonts.inter(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      applicant['role'] ?? 'Unknown Role',
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "offer : Rp${applicant['offerPrice']}",
                                      style: GoogleFonts.inter(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  print("tombol show profile ditekan");
                                },
                                child: const Text(
                                  "show profile >>",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.blue),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: () {
                              final status = applicant['status'] ?? 'pending';

                              if (status == 'pending') {
                                return [
                                  OutlinedButton(
                                    onPressed: () {
                                      controller.updateApplication(
                                          applicant['docId']);
                                      Get.back();
                                      Get.snackbar(
                                        'Berhasil',
                                        'Kamu telah memilih freelancer untuk job ini.',
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: Colors.green,
                                        colorText: Colors.white,
                                        duration: const Duration(seconds: 2),
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side:
                                          const BorderSide(color: Colors.green),
                                      minimumSize: const Size(90, 30),
                                    ),
                                    child: const Text(
                                      "accept",
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  OutlinedButton(
                                    onPressed: () {
                                      print("tombol reject ditekan");
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(color: Colors.red),
                                      minimumSize: const Size(90, 30),
                                    ),
                                    child: const Text(
                                      "reject",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ];
                              } else if (status == 'selected') {
                                return [
                                  Text(
                                    "waiting for applicant response within 10 m",
                                    style: GoogleFonts.inter(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 10),
                                  )
                                ];
                              } else {
                                return [
                                  const Text(
                                    "accepted",
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w600),
                                  )
                                ];
                              }
                            }(),
                          ),
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
