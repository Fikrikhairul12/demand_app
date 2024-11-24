import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../widgets/onboarding_widget.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 185, 224, 255),
      body: Obx(
        () => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: PageView(
                controller: controller.pageController,
                onPageChanged: (index) {
                  controller.currentPage.value = index;
                },
                children: [
                  onboardingPage(
                    title: 'Temukan Peluang Kerja Terbaik',
                    description:
                        'Dengan demand.id, Anda dapat mencari pekerjaan dan pengalaman yang sesuai dengan keahlian Anda, baik sebagai freelancer maupun pekerjaan tetap. Tunggu apa lagi, ribuan peluang menunggu Anda!',
                    imagePath: 'assets/images/icon-demand.png', // Ganti dengan gambar yang relevan
                  ),
                  onboardingPage(
                    title: 'Hubungkan Klien dan Freelancer',
                    description:
                        'Kami menghubungkan Anda dengan klien atau freelancer terbaik di bidangnya. Mulailah proyek dengan sistem pembayaran yang aman',
                    imagePath: 'assets/images/icon-demand.png', // Ganti dengan gambar yang relevan
                  ),
                  onboardingPage(
                    title: 'Raih Kesempatan, Wujudkan Impian',
                    description:
                        'Demand.Id adalah langkah awal untuk kesuksesan Anda. Dapatkan pekerjaan impian Anda, atau rekrut freelancer profesional untuk mewujudkan proyek Anda.',
                    imagePath: 'assets/images/icon-demand.png', // Ganti dengan gambar yang relevan
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3, // Jumlah halaman onboarding
                (index) => Obx(
                  () => Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: controller.currentPage.value == index
                          ? Colors.blue
                          : Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (controller.currentPage.value == 2) {
                  controller.skipOnboarding(); // Setelah halaman terakhir, arahkan ke login
                } else {
                  controller.nextPage();
                }
              },
              child: Text(controller.currentPage.value == 2 ? 'Mulai' : 'Next'),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: controller.skipOnboarding,
              child: Text('Lewati'),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
