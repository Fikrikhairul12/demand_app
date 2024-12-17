class HomeModel {
  final String title;
  final String createdAt;
  final String username;
  final String description; // Menambahkan deskripsi pekerjaan
  final double price; // Menambahkan harga pekerjaan
  bool isExpanded;

  HomeModel({
    required this.title,
    required this.createdAt,
    required this.username,
    required this.description,
    required this.price,
    this.isExpanded = false,
  });

  // Fungsi untuk membuat HomeModel dari Firestore snapshot
  factory HomeModel.fromFirestore(Map<String, dynamic> data) {
    return HomeModel(
      title: data['title'] ?? 'No title',
      createdAt: data['createdAt'] ?? 'No date',
      username: data['username'] ?? 'Unknown',
      description: data['description'] ?? 'No description', // Ambil deskripsi
      price: (data['price'] ?? 0).toDouble(), // Ambil harga dan ubah ke double
    );
  }
}
