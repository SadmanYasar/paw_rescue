import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<String> getUserAndRoles() async {
  final String email = FirebaseAuth.instance.currentUser!.email!;

  // Get the user document from Firestore where email matches
  final userDoc =
      await FirebaseFirestore.instance.collection('users').doc(email).get();

  // Check if the user document exists
  if (userDoc.exists) {
    final role = userDoc.data()!['role'] as String;
    return role;
  } else {
    // Document doesn't exist, set default role to "reporter"
    return 'reporter';
  }
}
