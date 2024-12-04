import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Fungsi untuk upload file ke Firebase Storage
  Future<String?> uploadFile(String filePath, String folder) async {
    try {
      final fileName = filePath.split('/').last;
      final ref = _storage.ref().child('$folder/$fileName');
      final file = File(filePath);

      // Cek apakah file ada
      if (!await file.exists()) {
        print('File tidak ditemukan: $filePath');
        return null; // Kembalikan null jika file tidak ada
      }

      // Tentukan metadata sesuai dengan jenis file
      String contentType = 'application/octet-stream'; // Default
      if (filePath.endsWith('.jpg') || filePath.endsWith('.jpeg')) {
        contentType = 'image/jpeg';
      } else if (filePath.endsWith('.png')) {
        contentType = 'image/png';
      } else if (filePath.endsWith('.pdf')) {
        contentType = 'application/pdf';
      }
      // Tambahkan jenis file lain sesuai kebutuhan

      final metadata = SettableMetadata(contentType: contentType);

      final uploadTask = ref.putFile(file, metadata);

      // Listen for state changes, errors, and completion of the upload.
      uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
        switch (taskSnapshot.state) {
          case TaskState.running:
            final progress = 100.0 *
                (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
            print("Upload is $progress% complete.");
            break;
          case TaskState.paused:
            print("Upload is paused.");
            break;
          case TaskState.canceled:
            print("Upload was canceled.");
            break;
          case TaskState.error:
            print("Upload failed.");
            break;
          case TaskState.success:
            print("Upload completed successfully.");
            break;
        }
      });

      await uploadTask.whenComplete(() {});
      return await ref.getDownloadURL();
    } catch (e) {
      print('File upload error: $e');
      return null; // Pastikan mengembalikan null jika gagal
    }
  }

  // Fungsi untuk membuat data pekerjaan ke Firestore
  Future<void> createJob(Map<String, dynamic> jobData) async {
    try {
      await _firestore.collection('jobs').add(jobData);
    } catch (e) {
      print('Error creating job: $e');
    }
  }
}
