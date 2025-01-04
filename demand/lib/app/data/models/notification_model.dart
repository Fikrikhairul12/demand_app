import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String userId;
  final String message;
  final String type;
  final DateTime timestamp;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.message,
    required this.type,
    required this.timestamp,
  });

  factory NotificationModel.fromFirestore(Map<String, dynamic> data, String id) {
    return NotificationModel(
      id: id,
      userId: data['userId'] ?? '',
      message: data['message'] ?? '',
      type: data['type'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}
