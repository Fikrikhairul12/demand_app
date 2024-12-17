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

class Job {
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
  final String createdAt;
  bool isExpanded; // Tambahan untuk toggle card

  Job({
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
    this.isExpanded = false, // Default false
  });

  factory Job.fromFirestore(Map<String, dynamic> data) {
    return Job(
      userId: data['userId'] ?? '',
      title: data['title'] ?? 'Untitled',
      description: data['description'] ?? 'No description',
      category: data['category'] ?? 'Uncategorized',
      jobType: data['jobType'] ?? 'Unknown',
      linkFile: data['linkFile'] ?? '',
      price: data['price'] ?? 0,
      paymentMethod: data['paymentMethod'] ?? 'Unknown',
      virtualAccount: data['virtualAccount'],
      isPayment: data['isPayment'] ?? false,
      createdAt: data['createdAt']?.toString() ?? 'No date',
      isExpanded: false, // Default false
    );
  }
}