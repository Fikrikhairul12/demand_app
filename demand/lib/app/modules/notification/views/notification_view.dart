import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/notification_controller.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 185, 224, 255),
      appBar: AppBar(
        backgroundColor: const Color(0xff016FCB),
        title: Image.asset(
          'assets/icons/demandtext.png',
        ),
      ),
      body: Obx(() {
        final notifications = controller.notifications;
        if (notifications.isEmpty) {
          return const Center(
            child: Text(
              "No notifications available",
              style: TextStyle(fontSize: 16),
            ),
          );
        }
        return ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.type,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('hh:mm a').format(notification.timestamp),
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        // ✅ Jika type == Accepted, tampilkan tombol
                        if (notification.type == 'Accepted') ...[
                          if (notification.status == 'pending') ...[
                            Row(
                              children: [
                                OutlinedButton(
                                  onPressed: () {
                                    controller.confirmAction(notification);
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.green),
                                    minimumSize: const Size(90, 30),
                                  ),
                                  child: const Text(
                                    'Confirm',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ),
                                OutlinedButton(
                                  onPressed: () {
                                    controller.cancelAction(notification);
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.red),
                                    minimumSize: const Size(90, 30),
                                  ),
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            )
                          ] else ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: notification.status == 'confirmed'
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: notification.status == 'confirmed'
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                              child: Text(
                                notification.status.capitalizeFirst ?? '',
                                style: TextStyle(
                                  color: notification.status == 'confirmed'
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ]
                        ]
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
