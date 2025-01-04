import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff016FCB),
        title: Image.asset(
          'assets/icons/demandtext.png',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signOut();
                Get.offAllNamed('/login');
              } catch (e) {
                print('Error during logout: $e');
              }
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final profile = controller.profile.value;
        if (profile == null) {
          return const Center(child: Text('No profile data found.'));
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 100,
                    color: const Color(0xff016FCB),
                    child: Center(
                      child: Text(
                        'bAckground gambar',
                        style: GoogleFonts.lexend(color: Colors.white),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -50,
                    left: 20,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(profile.profilePicture),
                      backgroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Username and Verified Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '@${profile.username}',
                    style: GoogleFonts.lexend(fontSize: 16),
                  ),
                  const SizedBox(width: 5),
                  const Icon(Icons.verified, color: Colors.blue, size: 18),
                ],
              ),

              // Name and Bio
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      color: Color(0xff016FCB),
                      child: Center(
                        child: Text(
                          profile.name,
                          style: GoogleFonts.lexend(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      '"${profile.bio}"',
                      style: GoogleFonts.lexend(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              // Contact Info
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.black),
                          borderRadius:
                              BorderRadius.circular(50),
                        ),
                        child: TextButton.icon(
                          onPressed: null,
                          icon: const Icon(Icons.phone, color: Colors.black),
                          label: Text(
                            profile.phone,
                            style: GoogleFonts.lexend(color: Colors.black),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.black),
                          borderRadius:
                              BorderRadius.circular(50),
                        ),
                        child: TextButton.icon(
                          onPressed: null,
                          icon: const Icon(Icons.email, color: Colors.black),
                          label: Text(
                            profile.email,
                            style: GoogleFonts.lexend(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // History and Portfolio Sections
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    _buildCard('History'),
                    _buildCard('Portfolio'),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30, right: 30),
        child: SizedBox(
          height: 50,
          width: 120,
          child: FloatingActionButton(
            onPressed: () {
              Get.toNamed('/license-application');
            },
            backgroundColor: const Color(0xff016FCB),
            child: Text(
              'Ajukan Lisensi',
              style: GoogleFonts.lexend(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.lexend(fontWeight: FontWeight.bold),
          ),
          Text(
            'show more >>',
            style: GoogleFonts.lexend(color: Colors.blue),
          ),
        ],
      ),
    );
  }
}
