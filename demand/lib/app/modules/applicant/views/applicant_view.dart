import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/applicant_controller.dart';

class ApplicantView extends GetView<ApplicantController> {
  const ApplicantView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ApplicantView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ApplicantView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
