import 'package:demand/app/data/models/notification_model.dart';
import 'package:demand/app/data/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  final NotificationService _notificationService = NotificationService();
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;

  String get userId {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid ?? '';
  }

  @override
  void onInit() {
    super.onInit();
    _notificationService.fetchNotifications(userId).listen((data) {
      notifications.value = data;
    });
  }
}
