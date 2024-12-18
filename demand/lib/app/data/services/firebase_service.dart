import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demand/app/data/models/home_model.dart';
import 'package:demand/app/data/models/job_model.dart';
import 'package:demand/app/data/models/license_model.dart';
import 'package:intl/intl.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Fungsi untuk membuat data pekerjaan ke Firestore
  Future<void> createJob(Map<String, dynamic> jobData) async {
    try {
      await _firestore.collection('jobs').add(jobData);
    } catch (e) {
      print('Error creating job: $e');
    }
  }

  Future<bool> fetchUserLicense(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        return userDoc.data()?['license'] ?? false;
      } else {
        throw Exception("User document not found.");
      }
    } catch (e) {
      print("Error fetching license: $e");
      return false;
    }
  }
}

class LicenseApplicationService {
  static Future<void> submitLicenseApplication(
      String userId, LicenseApplicationModel application) async {
    try {
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(userId);

      // Add the license application as a sub-collection
      await userDoc.collection('licenses').add(application.toJson());
    } catch (e) {
      throw Exception('Failed to submit license application: $e');
    }
  }
}

class JobService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch jobs by current user
  Future<List<Job>> fetchJobsByUser(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('jobs')
          .where('userId', isEqualTo: userId)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        // Validasi semua field yang mungkin null
        if (data['userId'] == null || data['title'] == null) {
          throw Exception('Incomplete job data: $data');
        }
        return Job.fromFirestore(data);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch jobs: $e');
    }
  }

  // Fetch username by userId
  Future<String?> fetchUsername(String userId) async {
    try {
      final docSnapshot =
          await _firestore.collection('users').doc(userId).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null &&
            data.containsKey('username') &&
            data['username'] != null) {
          return data['username'] as String?;
        } else {
          return 'Unknown User'; // Jika username tidak ditemukan, kembalikan nilai default
        }
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch username: $e');
    }
  }
}

class HomeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Mengambil semua pekerjaan dari Firestore
  Future<List<HomeModel>> fetchJobs() async {
    try {
      final querySnapshot = await _firestore.collection('jobs').get();
      final jobs = await Future.wait(querySnapshot.docs.map((doc) async {
        String userId = doc['userId'] ?? '';

        String username = await _getUsername(userId);

        String createdAt = _formatDate(doc['createdAt']);

        return HomeModel(
          id: doc.id,
          title: doc['title'] ?? 'No title',
          createdAt: createdAt,
          username: username,
          description: doc['description'] ?? 'No description', // Ambil deskripsi
          price: (doc['price'] ?? 0).toDouble(), // Ambil harga
        );
      }));

      return jobs;
    } catch (e) {
      throw Exception('Failed to fetch jobs: $e');
    }
  }

  // Fungsi untuk mendapatkan username berdasarkan userId
  Future<String> _getUsername(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      return userDoc.exists ? userDoc['username'] ?? 'Unknown' : 'Unknown';
    } catch (e) {
      return 'Unknown';
    }
  }

  // Fungsi untuk mengubah format tanggal
  String _formatDate(dynamic createdAt) {
    DateTime date;

    if (createdAt is Timestamp) {
      date = createdAt.toDate();
    } else if (createdAt is String) {
      date = DateTime.parse(createdAt);
    } else {
      date = DateTime.now();
    }

    final formatter = DateFormat('HH:mm dd-MMM');
    return formatter.format(date);
  }
}
