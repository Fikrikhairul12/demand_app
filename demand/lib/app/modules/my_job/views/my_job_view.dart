import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/my_job_controller.dart';

class MyJobView extends GetView<MyJobController> {
  const MyJobView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyJobView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'MyJobView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
      floatingActionButton: Padding(
        padding:
            const EdgeInsets.only(bottom: 30, right: 30),
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
