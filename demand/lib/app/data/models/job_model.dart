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
  final String status;

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
    this.status = 'uploaded',
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
      'status': status,
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
  final String status;
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
    required this.status,
    this.isExpanded = false, // Default false
  });

  factory Job.fromFirestore(Map<String, dynamic> data) {
    return Job(
      userId: data['userId'] ?? '',
      title: data['title'] ?? 'Untitled',
      description: data['description'] ?? 'No description',
      category: data['category'] ?? 'Uncategorized',
      jobType: data['jobType'] ?? 'Unknown',
      linkFile: data.containsKey('file') ? data['file'] : '',
      price: data['price'] ?? 0,
      paymentMethod: data['paymentMethod'] ?? 'Unknown',
      virtualAccount: data['virtualAccount'],
      status: data['status'],
      isPayment: data['isPayment'] ?? false,
      createdAt: data['createdAt']?.toString() ?? 'No date',
      isExpanded: false, // Default false
    );
  }

  @override
  String toString() {
    return '''
    Job(
      userId: $userId,
      title: $title,
      description: $description,
      category: $category,
      jobType: $jobType,
      link: $linkFile,
      price: $price,
      paymentMethod: $paymentMethod,
      virtualAccount: $virtualAccount,
      isPayment: $isPayment,
      createdAt: $createdAt,
      isExpanded: $isExpanded
    )
  ''';
  }
}

