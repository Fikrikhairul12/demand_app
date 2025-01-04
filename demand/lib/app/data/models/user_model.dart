class UserModel {
  final String id; // documentId dari koleksi users
  final String fullName;
  final String email;
  final bool license;
  final String phone;
  final String profilePicture;
  final String role;
  final String username;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.license,
    required this.phone,
    required this.profilePicture,
    required this.role,
    required this.username,
  });

  // Factory untuk mapping dari Firestore ke model
  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id, // documentId
      fullName: map['name'] ?? '',
      email: map['email'] ?? '',
      license: map['license'] ?? false,
      phone: map['phone'] ?? '',
      profilePicture: map['profilePicture'] ?? '',
      role: map['role'] ?? '',
      username: map['username'] ?? '',
    );
  }
}