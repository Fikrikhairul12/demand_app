import 'package:flutter/material.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import '../controllers/license_application_controller.dart';

class LicenseApplicationView extends GetView<LicenseApplicationController> {
  const LicenseApplicationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('License Application'),
        centerTitle: true,
      ),
      body: Obx(() {
        return Stepper(
          currentStep: controller.currentStep.value,
          onStepContinue: controller.handleContinue,
          onStepCancel: controller.handleCancel,
          steps: [
            //TODO: Step 1
            Step(
              title: const Text('Personal Details'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama Lengkap
                  TextField(
                    controller: TextEditingController(
                      text: controller.fullName.value,
                    ),
                    decoration:
                        const InputDecoration(labelText: 'Nama Lengkap'),
                    readOnly: true,
                  ),
                  const SizedBox(height: 8),

                  // Nomor KTP
                  TextField(
                    decoration: const InputDecoration(labelText: 'Nomor KTP'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      controller.ktpNumber.value = value;
                      controller.validateStep1();
                    },
                  ),
                  const SizedBox(height: 8),

                  // Tanggal Lahir
                  TextField(
                    controller: TextEditingController(
                      text: controller.dateOfBirth.value,
                    ),
                    decoration:
                        const InputDecoration(labelText: 'Tanggal Lahir'),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );

                      if (pickedDate != null) {
                        controller.dateOfBirth.value = "${pickedDate.toLocal()}"
                            .split(' ')[0]; // Format YYYY-MM-DD
                      }
                    },
                    onChanged: (value) {
                      controller.ktpNumber.value = value;
                      controller.validateStep1();
                    },
                  ),
                  const SizedBox(height: 8),

                  // Jenis Kelamin
                  DropdownButton<String>(
                    value: controller.gender.value.isEmpty
                        ? null
                        : controller.gender.value,
                    hint: const Text('Pilih Jenis Kelamin'),
                    items: const [
                      DropdownMenuItem(
                          value: 'Laki-laki', child: Text('Laki-laki')),
                      DropdownMenuItem(
                          value: 'Perempuan', child: Text('Perempuan')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        controller.gender.value = value;
                        controller.validateStep1();
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // Email
                  TextField(
                    controller: TextEditingController(
                      text: controller.email.value,
                    ),
                    decoration: const InputDecoration(labelText: 'Email'),
                    readOnly: true,
                  ),
                  const SizedBox(height: 8),

                  // Nomor Telepon
                  TextField(
                    controller: TextEditingController(
                      text: controller.phone.value,
                    ),
                    decoration:
                        const InputDecoration(labelText: 'Nomor Telepon'),
                    readOnly: true,
                  ),
                ],
              ),
            ),
            // TODO: Step 2
            Step(
              title: const Text('Professional Information'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nomor Rekening
                  TextField(
                    decoration:
                        const InputDecoration(labelText: 'Nomor Rekening'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      controller.accountNumber.value = value;
                    },
                  ),
                  const SizedBox(height: 8),

                  // Nama Bank
                  DropdownButton<String>(
                    value: controller.bankName.value.isEmpty
                        ? null
                        : controller.bankName.value,
                    hint: const Text('Pilih Nama Bank'),
                    items: const [
                      DropdownMenuItem(value: 'BNI', child: Text('BNI')),
                      DropdownMenuItem(value: 'BCA', child: Text('BCA')),
                      DropdownMenuItem(value: 'BRI', child: Text('BRI')),
                      DropdownMenuItem(
                          value: 'Bank Mandiri', child: Text('Bank Mandiri')),
                      DropdownMenuItem(value: 'BTN', child: Text('BTN')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        controller.bankName.value = value;
                      }
                    },
                  ),
                ],
              ),
            ),
            //TODO: Step 3
            Step(
              title: const Text('Supporting Statements and Documents'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Job Type (Radio Buttons)
                  const Text('Tipe Pekerjaan yang Ditekuni'),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Radio<String>(
                              value: 'Full-Time',
                              groupValue: controller.jobType.value,
                              onChanged: (value) {
                                controller.jobType.value = value!;
                              },
                            ),
                            const Text('Full-Time'),
                          ],
                        ),
                        Row(
                          children: [
                            Radio<String>(
                              value: 'Part-Time',
                              groupValue: controller.jobType.value,
                              onChanged: (value) {
                                controller.jobType.value = value!;
                              },
                            ),
                            const Text('Part-Time'),
                          ],
                        ),
                        Row(
                          children: [
                            Radio<String>(
                              value: 'Freelance',
                              groupValue: controller.jobType.value,
                              onChanged: (value) {
                                controller.jobType.value = value!;
                              },
                            ),
                            const Text('Freelance'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButton<String>(
                    value: controller.skillCategory.value.isEmpty
                        ? null
                        : controller.skillCategory.value,
                    hint: const Text('Pilih Kategori Keahlian'),
                    items: const [
                      DropdownMenuItem(value: 'Desain', child: Text('Desain')),
                      DropdownMenuItem(
                          value: 'Penulisan', child: Text('Penulisan')),
                      DropdownMenuItem(value: 'IT', child: Text('IT')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        controller.skillCategory.value = value;
                      }
                    },
                  ),
                  const SizedBox(height: 18),

                  // Motivasi dan Tujuan
                  const Text('Motivasi dan Tujuan'),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Tuliskan motivasi Anda...',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    onChanged: (value) {
                      controller.motivation.value = value;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Checkbox Agreement
                  CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const Text(
                        'Saya menyatakan bahwa semua data yang saya masukkan adalah benar.'),
                    value: controller.isDeclarationChecked.value,
                    onChanged: (value) {
                      controller.isDeclarationChecked.value = value!;
                    },
                  ),
                  CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const Text(
                        'Saya menyetujui kebijakan dan ketentuan layanan aplikasi ini.'),
                    value: controller.isPolicyChecked.value,
                    onChanged: (value) {
                      controller.isPolicyChecked.value = value!;
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
