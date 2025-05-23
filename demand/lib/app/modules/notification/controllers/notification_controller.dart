import 'package:cloud_firestore/cloud_firestore.dart';
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

  void confirmAction(NotificationModel notif) async {
    try {
      final applyId = notif.appId;
      if (applyId.isEmpty) {
        print("❌ applyId tidak ditemukan di notifikasi.");
        return;
      }

      final applicationSnapshot = await FirebaseFirestore.instance
          .collection('applications')
          .doc(applyId)
          .get();

      if (!applicationSnapshot.exists) {
        print("❌ Dokumen aplikasi tidak ditemukan.");
        return;
      }

      final applicationData = applicationSnapshot.data()!;
      final jobId = applicationData['jobId'];

      // 1. Update status dan hapus field selectedAt
      await FirebaseFirestore.instance
          .collection('applications')
          .doc(applyId)
          .update({
        'status': 'accepted',
        'selectedAt': FieldValue.delete(),
      });
      // 2. Update status job menjadi 'waiting'
      await FirebaseFirestore.instance
          .collection('jobs')
          .doc(jobId)
          .update({'status': 'waiting'});

      // 3. Ambil userId pemilik job
      final jobSnapshot =
          await FirebaseFirestore.instance.collection('jobs').doc(jobId).get();

      if (!jobSnapshot.exists) {
        print("❌ Job tidak ditemukan.");
        return;
      }

      final jobOwnerId = jobSnapshot.data()!['userId'];

      // 4. Ambil username user saat ini
      final currentUser = FirebaseAuth.instance.currentUser;
      final currentUserData = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser?.uid)
          .get();

      final username = currentUserData.data()?['username'] ?? 'Freelancer';

      // 5. Kirim notifikasi ke client
      await FirebaseFirestore.instance.collection('notifications').add({
        'type': 'Confirm',
        'timestamp': DateTime.now(),
        'userId': jobOwnerId,
        'message':
            '$username telah setuju mengerjakan job anda, silakan lanjut ke pembayaran.',
      });

      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(notif.id)
          .update({'status': 'confirmed'});

      print("✅ Lamaran dikonfirmasi & notifikasi dikirim ke client.");
    } catch (e) {
      print("❌ Gagal konfirmasi lamaran: $e");
    }
  }

  void cancelAction(NotificationModel notif) async {
    await FirebaseFirestore.instance
        .collection('notifications')
        .doc(notif.id)
        .update({'status': 'cancelled'});

    // _notificationService.deleteNotification(notif.id);
    print("❌ Cancelled: ${notif.id}");
  }
}
