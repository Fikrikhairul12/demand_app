import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/admin_dashboard_controller.dart';

class AdminDashboardView extends GetView<AdminDashboardController> {
  const AdminDashboardView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AdminDashboardView'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signOut();
                Get.offAllNamed(
                    '/login'); // Arahkan ke halaman login setelah logout
              } catch (e) {
                print('Error during logout: $e');
              }
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'AdminDashboardView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
