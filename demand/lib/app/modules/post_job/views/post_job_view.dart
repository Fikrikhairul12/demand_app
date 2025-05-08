import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/post_job_controller.dart';

class PostJobView extends GetView<PostJobController> {
  const PostJobView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Job'),
        centerTitle: true,
      ),
      body: Obx(
        () => Stepper(
          currentStep: controller.currentStep.value,
          onStepCancel: () {
            if (controller.currentStep.value > 0) {
              controller.currentStep.value--;
            }
          },
          onStepContinue: controller.currentStep.value < 2
              ? () {
                  if (controller.isNextEnabled.value) {
                    controller.currentStep.value++;
                  }
                }
              : null,
          controlsBuilder: (BuildContext context, ControlsDetails details) {
            if (controller.currentStep.value == 2) {
              return Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (controller.validateStep3()) {
                          // await controller.completePayment();
                          await controller.submitJob();
                        } else {
                          Get.snackbar(
                            'Error',
                            'Please complete all the required fields.',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: details.onStepCancel,
                      child: const Text('Back'),
                    ),
                  ),
                ],
              );
            } else {
              return Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: details.onStepContinue,
                      child: const Text('Continue'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: details.onStepCancel,
                      child: const Text('Back'),
                    ),
                  ),
                ],
              );
            }
          },
          steps: [
            //! step 1 detail job
            Step(
              title: const Text('Job Details'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: 'Job Title'),
                    onChanged: (value) {
                      controller.title = value;
                      controller.validateStep1();
                    },
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Description'),
                    onChanged: (value) {
                      controller.description = value;
                      controller.validateStep1();
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: controller.selectedCategory.value.isEmpty
                        ? null
                        : controller.selectedCategory.value,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                    ),
                    items: controller.jobCategories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      controller.selectedCategory.value = value!;
                      controller.validateStep1();
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text('Job Type'),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('Online'),
                          value: 'Online',
                          groupValue: controller.jobType.value,
                          onChanged: (value) {
                            controller.jobType.value = value!;
                            controller.validateStep1();
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('Offline'),
                          value: 'Offline',
                          groupValue: controller.jobType.value,
                          onChanged: (value) {
                            controller.jobType.value = value!;
                            controller.validateStep1();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            //! step 2 upload file
            Step(
              title: const Text('Upload Files'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    decoration: const InputDecoration(
                        labelText: 'Link File',
                        hintText: 'https://example.com/file.pdf'),
                    onChanged: (value) {
                      controller.linkFile = value;
                      controller.validateStep2();
                    },
                  ),
                ],
              ),
            ),
            //! step 3 pembayaran
            Step(
              title: const Text('Pricing and Payment'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Price (IDR)'),
                    onChanged: (value) {
                      controller.price = int.tryParse(value) ?? 0;
                    },
                  ),
                  const SizedBox(height: 20),
                  // Obx(
                  //   () => DropdownButtonFormField<String>(
                  //     decoration:
                  //         const InputDecoration(labelText: 'Payment Method'),
                  //     value: controller.paymentMethod.isEmpty
                  //         ? null
                  //         : controller.paymentMethod,
                  //     items: controller.getPaymentMethods().map((method) {
                  //       return DropdownMenuItem<String>(
                  //         value: method,
                  //         child: Text(method),
                  //       );
                  //     }).toList(),
                  //     onChanged: (value) {
                  //       controller.paymentMethod = value!;
                  //       if (controller.jobType.value == 'Online' &&
                  //           value == 'Tunai') {
                  //         Get.snackbar(
                  //           'Invalid Payment Method',
                  //           'Cash payment is not available for online jobs.',
                  //           snackPosition: SnackPosition.BOTTOM,
                  //           backgroundColor: Colors.red,
                  //           colorText: Colors.white,
                  //         );
                  //         controller.paymentMethod =
                  //             ''; // Reset jika memilih "Tunai"
                  //       }
                  //     },
                  //   ),
                  // ),
                  const SizedBox(height: 20),
                  // Display Virtual Account (Jika Tipe Online)
                  // Obx(() {
                  //   if (controller.jobType.value == 'Online') {
                  //     return Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         const Text(
                  //           'Virtual Account:',
                  //           style: TextStyle(fontWeight: FontWeight.bold),
                  //         ),
                  //         Text(controller.virtualAccount.value.isEmpty
                  //             ? 'Not generated yet'
                  //             : controller.virtualAccount.value),
                  //         ElevatedButton(
                  //           onPressed: () {
                  //             controller.generateVirtualAccount();
                  //           },
                  //           child: const Text('Generate Virtual Account'),
                  //         ),
                  //       ],
                  //     );
                  //   }
                  //   return const SizedBox.shrink();
                  // }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
