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
              child: ListTile(
                title: Text(
                  notification.type,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(notification.message),
                trailing: Text(
                  DateFormat('hh:mm a').format(notification.timestamp),
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
