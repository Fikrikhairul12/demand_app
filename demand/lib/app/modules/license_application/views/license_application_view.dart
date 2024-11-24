import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/license_application_controller.dart';

class LicenseApplicationView extends GetView<LicenseApplicationController> {
  const LicenseApplicationView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LicenseApplicationView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'LicenseApplicationView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
