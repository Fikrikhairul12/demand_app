import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/license_model.dart';

class LicenseService extends GetxService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Mengambil data sub-collection 'licenses' dari setiap user
  Future<List<GetLicense>> getAllLicenses() async {
    List<GetLicense> licenses = [];
    try {
      // Ambil semua dokumen dari koleksi 'users'
      QuerySnapshot usersSnapshot = await _db.collection('users').get();

      // Iterasi untuk mengambil sub-collection 'licenses' untuk setiap user
      for (var userDoc in usersSnapshot.docs) {
        QuerySnapshot licenseSnapshot =
            await userDoc.reference.collection('licenses').get();

        // Menambahkan data dari sub-collection ke dalam list
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
}
