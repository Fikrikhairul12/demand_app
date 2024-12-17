import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demand/app/data/models/user_model.dart';
import 'package:get/get.dart';
import '../models/license_model.dart';

class LicenseService extends GetxService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<GetLicense>> getAllLicenses() async {
    List<GetLicense> licenses = [];
    try {
      QuerySnapshot usersSnapshot = await _db.collection('users').get();

      for (var userDoc in usersSnapshot.docs) {
        QuerySnapshot licenseSnapshot =
            await userDoc.reference.collection('licenses').get();

        for (var licenseDoc in licenseSnapshot.docs) {
          licenses.add(GetLicense.fromMap(
              licenseDoc.data() as Map<String, dynamic>, licenseDoc.id));
        }
      }
    } catch (e) {
      print("Error fetching licenses: $e");
    }
    return licenses;
  }

  // Fungsi untuk mengubah status license menjadi "agree"
  Future<void> approveLicense(String userId, String licenseId) async {
    try {
      // Update status di sub-koleksi licenses
      await _db
          .collection('users')
          .doc(userId)
          .collection('licenses')
          .doc(licenseId)
          .update({'status': 'agree'});

      // Update field license pada dokumen user
      await _db.collection('users').doc(userId).update({'license': true});
    } catch (e) {
      print("Error approving license: $e");
    }
  }

  // Fungsi untuk mengubah status license menjadi "disagree"
  Future<void> rejectLicense(String userId, String licenseId) async {
    try {
      await _db
          .collection('users')
          .doc(userId)
          .collection('licenses')
          .doc(licenseId)
          .update({'status': 'disagree'});
    } catch (e) {
      print("Error rejecting license: $e");
    }
  }

  // Fungsi untuk mendapatkan semua data user
  Future<List<UserModel>> getAllUsers() async {
    try {
      QuerySnapshot usersSnapshot = await _db.collection('users').get();

      return usersSnapshot.docs.map((doc) {
        // Ambil documentId dan mapping data
        return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print("Error fetching users: $e");
      return [];
    }
  }
}
