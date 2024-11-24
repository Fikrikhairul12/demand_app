class UserModel {
  final String name;
  final String email;
  final String dateOfBirth;
  final String phone;
  final String profilePicture;
  final String license;

  UserModel({
    required this.name,
    required this.email,
    required this.dateOfBirth,
    required this.phone,
    required this.profilePicture,
    required this.license,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] as String,
      email: json['email'] as String,
      dateOfBirth: json['date_of_birth'] as String,
      phone: json['phone'] as String,
      profilePicture: json['profile_picture'] as String,
      license: json['license'] as String,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'date_of_birth': dateOfBirth,
      'phone': phone,
      'profile_picture': profilePicture,
      'license': license,
    };
  }
}
