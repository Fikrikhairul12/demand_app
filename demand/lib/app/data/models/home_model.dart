class HomeModel {
  final String title;
  final String createdAt;
  final String username; // Menambahkan username

  HomeModel(
      {required this.title, required this.createdAt, required this.username});

  // Fungsi untuk membuat Job dari Firestore snapshot
  factory HomeModel.fromFirestore(Map<String, dynamic> data) {
    return HomeModel(
      title: data['title'] ?? 'No title',
      createdAt: data['createdAt'] ?? 'No date',
      username: data['username'] ?? 'Unknown', // Menambahkan username
    );
  }
}
