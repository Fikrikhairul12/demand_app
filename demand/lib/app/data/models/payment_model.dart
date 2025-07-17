class Payment {
  final String userId;
  final String jobId;
  final int price;

  Payment({
    required this.userId,
    required this.jobId,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'jobId': jobId,
      'price': price,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }
}
