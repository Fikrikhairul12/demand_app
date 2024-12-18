class HomeModel {
  final String id;
  final String title;
  final String createdAt;
  final String username;
  final String description;
  final double price;
  bool isExpanded;

  HomeModel({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.username,
    required this.description,
    required this.price,
    this.isExpanded = false,
  });

  // Fungsi untuk membuat HomeModel dari Firestore snapshot
  factory HomeModel.fromFirestore(String id, Map<String, dynamic> data) {
    return HomeModel(
      id: id,
      title: data['title'] ?? 'No title',
      createdAt: data['createdAt'] ?? 'No date',
      username: data['username'] ?? 'Unknown',
      description: data['description'] ?? 'No description', // Ambil deskripsi
      price: (data['price'] ?? 0).toDouble(), // Ambil harga dan ubah ke double
    );
  }
}
