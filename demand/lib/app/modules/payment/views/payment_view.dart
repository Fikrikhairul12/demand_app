import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/payment_controller.dart';

class PaymentView extends GetView<PaymentController> {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Payment',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Obx(() {
        final imageSelected = controller.selectedImage.value != null;
        if (controller.applicants.isEmpty) {
          return const Center(
              child: Text('Tidak ada freelance yang accepted.'));
        }

        return ListView.builder(
          itemCount: controller.applicants.length,
          itemBuilder: (context, index) {
            final applicant = controller.applicants[index];
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Job Detail',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('Title : ${controller.job.title}'),
                  Text('Description : ${controller.job.description}'),
                  Text('Category : ${controller.job.category}'),
                  Text('Link : ${controller.job.linkFile}'),
                  const SizedBox(height: 20),
                  const Text(
                    'Rincian Harga',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Penawaran Harga'),
                      Text('Rp. ${applicant['offerPrice']}.-'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Metode Pembayaran',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: 'QRIS',
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'QRIS', child: Text('QRIS')),
                    ],
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 120,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      'ini barcode',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await controller.pickImageFromGallery();
                      if (controller.selectedImage.value != null) {
                        Get.snackbar(
                          'Berhasil',
                          'Foto berhasil dipilih!',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green.shade100,
                          colorText: Colors.black,
                        );
                      }
                    },
                    icon: Icon(
                        imageSelected ? Icons.check_circle : Icons.upload_file),
                    label: Text(
                      imageSelected
                          ? 'Foto Diterima'
                          : 'Upload Bukti Pembayaran',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          imageSelected ? Colors.blueGrey : Colors.green,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 12),
                        ),
                        child: const Text('Preview'),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 12),
                        ),
                        child: const Text('Submit'),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
