import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:collection/collection.dart';

Future<String> getUserAndRoles() async {
  try {
    final String email = FirebaseAuth.instance.currentUser!.email!;
    print(email);

    // Get the user document from Firestore where email matches
    final userDocs = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    final userDoc = userDocs.docs.firstOrNull;
    if (userDoc == null) {
      // Document doesn't exist, set default role to "reporter"
      return 'reporter';
    }

    print(userDoc.data());
    final role = userDoc.get('role') as String;
    print(role);
    return role;
  } catch (e) {
    print('An error occurred: $e');
    // Handle the error here or rethrow it if necessary
    throw e;
  }
}
