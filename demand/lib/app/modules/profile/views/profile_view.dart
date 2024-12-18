import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProfileView'),
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
          'ProfileView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30, right: 30),
        child: SizedBox(
          height: 50,
          width: 120,
          child: FloatingActionButton(
            onPressed: () {
              Get.toNamed('/license-application');
            },
            backgroundColor: Colors.blue,
            child: const Text(
              'Ajukan Lisensi',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
