import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/profile_completion_controller.dart';

class ProfileCompletionView extends GetView<ProfileCompletionController> {
  const ProfileCompletionView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProfileCompletionView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ProfileCompletionView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
