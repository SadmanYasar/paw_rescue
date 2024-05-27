import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<String> getUserAndRoles() async {
  final String email = FirebaseAuth.instance.currentUser!.email!;
  print(email);

  // Get the user document from Firestore where email matches
  final userDoc = await FirebaseFirestore.instance
      .collection('users')
      .where('email', isEqualTo: email)
      .get()
      .then((value) => value.docs.first);

  print(userDoc.data());
  // Check if the user document exists
  if (userDoc.exists) {
    final role = userDoc.get('role') as String;
    print(role);
    return role;
  } else {
    // Document doesn't exist, set default role to "reporter"
    return 'reporter';
  }
}
