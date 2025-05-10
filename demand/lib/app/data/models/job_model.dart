class JobModel {
  final String userId;
  final String title;
  final String description;
  final String category;
  final String jobType;
  final String linkFile;
  final int price;
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
    required this.createdAt,
    this.status = 'pending',
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
      status: data['status'],
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
      createdAt: $createdAt,
      isExpanded: $isExpanded
    )
  ''';
  }
}

class DataJob {
  final String jobId;
  final String title;
  final String description;
  final String type;
  final String status;
  final String userId;
  final String username; // Tambahkan properti username

  DataJob({
    required this.jobId,
    required this.title,
    required this.description,
    required this.type,
    required this.status,
    required this.userId,
    required this.username, // Tambahkan parameter username
  });

  factory DataJob.fromFirestore(Map<String, dynamic> data, String id, String username) {
    return DataJob(
      jobId: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      type: data['jobType'] ?? '',
      status: data['status'] ?? '',
      userId: data['userId'] ?? '',
      username: username, // Inisialisasi username
    );
  }
}
