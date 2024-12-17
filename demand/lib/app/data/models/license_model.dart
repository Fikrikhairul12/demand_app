class LicenseApplicationModel {
  final String fullName;
  final String ktpNumber;
  final String dateOfBirth;
  final String gender;
  final String email;
  final String phone;
  final String accountNumber;
  final String bankName;
  final String skillCategory;
  final String jobType;
  final String motivation;
  final String status;

  LicenseApplicationModel({
    required this.fullName,
    required this.ktpNumber,
    required this.dateOfBirth,
    required this.gender,
    required this.email,
    required this.phone,
    required this.accountNumber,
    required this.bankName,
    required this.skillCategory,
    required this.jobType,
    required this.motivation,
    this.status = 'pending',
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'ktpNumber': ktpNumber,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'email': email,
      'phone': phone,
      'accountNumber': accountNumber,
      'bankName': bankName,
      'skillCategory': skillCategory,
      'jobType': jobType,
      'motivation': motivation,
      'status': status,
    };
  }
}

class GetLicense {
  String id;
  String gender;
  String phone;
  String motivation;
  String fullName;
  String jobType;
  String email;
  String skillCategory;
  String ktpNumber;
  String status;
  bool isExpanded;


  GetLicense({
    required this.id,
    required this.gender,
    required this.phone,
    required this.motivation,
    required this.fullName,
    required this.jobType,
    required this.email,
    required this.skillCategory,
    required this.ktpNumber,
    required this.status,
    this.isExpanded = false,
  });

  // Membuat dari Map (Firebase Snapshot)
  factory GetLicense.fromMap(Map<String, dynamic> data, String documentId) {
    return GetLicense(
      id: documentId,
      gender: data['gender'] ?? '',
      phone: data['phone'] ?? '',
      motivation: data['motivation'] ?? '',
      fullName: data['fullName'] ?? '',
      jobType: data['jobType'] ?? '',
      email: data['email'] ?? '',
      skillCategory: data['skillCategory'] ?? '',
      ktpNumber: data['ktpNumber'] ?? '',
      status: data['status'] ?? 'pending',
    );
  }

  // Mengubah ke Map (untuk menyimpan ke Firebase)
  Map<String, dynamic> toMap() {
    return {
      'gender': gender,
      'phone': phone,
      'motivation': motivation,
      'fullName': fullName,
      'jobType': jobType,
      'email': email,
      'skillCategory': skillCategory,
      'ktpNumber': ktpNumber,
      'status': status,
    };
  }
}
