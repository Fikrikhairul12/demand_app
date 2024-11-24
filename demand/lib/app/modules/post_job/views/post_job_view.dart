import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/post_job_controller.dart';

class PostJobView extends GetView<PostJobController> {
  const PostJobView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PostJobView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PostJobView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
