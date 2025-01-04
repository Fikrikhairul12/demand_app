class Profile {
  final String username;
  final String profilePicture;
  final String name;
  final String bio;
  final String phone;
  final String email;

  Profile({
    required this.username,
    required this.profilePicture,
    required this.name,
    required this.bio,
    required this.phone,
    required this.email,
  });

  factory Profile.fromFirestore(Map<String, dynamic> data) {
    return Profile(
      username: data['username'] ?? '',
      profilePicture: data['profilePicture'] ?? '',
      name: data['name'] ?? '',
      bio: data['bio'] ?? '',
      phone: data['phone'] ?? '',
      email: data['email'] ?? '',
    );
  }
}
