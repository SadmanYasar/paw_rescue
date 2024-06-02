import 'dart:async'; // new
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:paw_rescue/services/user_service.dart';

import '../firebase_options.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  bool _loggedIn = false;
  bool _isRescuer = false;
  bool get loggedIn => _loggedIn;
  bool get isRescuer => _isRescuer;
  bool isLoading = false;

  // StreamSubscription<QuerySnapshot>? _guestBookSubscription;
  // List<GuestBookMessage> _guestBookMessages = [];
  // List<GuestBookMessage> get guestBookMessages => _guestBookMessages;

  int currentIndex = 0;

  Future<void> init() async {
    // isLoading = true;
    // notifyListeners();

    // await Firebase.initializeApp(
    //     options: DefaultFirebaseOptions.currentPlatform);

    // FirebaseUIAuth.configureProviders([
    //   EmailAuthProvider(),
    // ]);

    FirebaseAuth.instance.userChanges().listen((user) async {
      if (user != null) {
        _loggedIn = true;
        _isRescuer = await getUserAndRoles() == 'rescuer' ? true : false;
        print(_isRescuer);
        // _guestBookSubscription = FirebaseFirestore.instance
        //     .collection('guestbook')
        //     .orderBy('timestamp', descending: true)
        //     .snapshots()
        //     .listen((snapshot) {
        //   _guestBookMessages = [];
        //   for (final document in snapshot.docs) {
        //     _guestBookMessages.add(
        //       GuestBookMessage(
        //         name: document.data()['name'] as String,
        //         message: document.data()['text'] as String,
        //       ),
        //     );
        //   }
        //   notifyListeners();
        // });
      } else {
        _loggedIn = false;
        _isRescuer = false;
        currentIndex = 0;
        // _guestBookMessages = [];
        // _guestBookSubscription?.cancel();
      }

      isLoading = false;
      notifyListeners();
    });
  }
}
