import 'package:cloud_firestore/cloud_firestore.dart';

Future<String?> getUserRole(String uid) async {
  try {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    if (doc.exists) {
      return doc['role'] as String;
    }
  } catch (e) {
    print('Error fetching role: $e');
  }
  return null;
}
