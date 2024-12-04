import 'package:get/get.dart';

class JobModel {
  final String userId;
  final String title;
  final String description;
  final String category;
  final String jobType;
  final String linkFile;
  final int price;
  final String paymentMethod;
  final String? virtualAccount;
  final bool isPayment;
  final DateTime createdAt;

  JobModel({
    required this.userId,
    required this.title,
    required this.description,
    required this.category,
    required this.jobType,
    required this.linkFile,
    required this.price,
    required this.paymentMethod,
    this.virtualAccount,
    required this.isPayment,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'category': category,
      'jobType': jobType,
      'price': price,
      'file': linkFile,
      'paymentMethod': paymentMethod,
      'virtualAccount': virtualAccount,
      'isPayment': isPayment,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
