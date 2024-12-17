// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:demand/app/data/models/user_model.dart';

// class UserService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<void> addUser(UserModel user, String uid) async {
//     await _firestore.collection('users').doc(uid).set(user.toFirestore());
//   }

//   Future<UserModel?> getUser(String uid) async {
//     final snapshot = await _firestore.collection('users').doc(uid).get();
//     if (snapshot.exists) {
//       return UserModel.fromFirestore(snapshot.data()!);
//     }
//     return null;
//   }
// }
