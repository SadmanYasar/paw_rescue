import 'package:firebase_auth/firebase_auth.dart' // new
    hide
        EmailAuthProvider,
        PhoneAuthProvider; // new
import 'package:flutter/material.dart'; // new
import 'package:provider/provider.dart'; // new

import '../widgets/app_state.dart'; // new
import '../widgets/authentication.dart'; // new

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Paw Rescue'),
      ),
      body: ListView(
        children: <Widget>[
          Image.asset(
            'assets/logo.png',
            width: 128,
            height: 128,
          ),
          //a horizontal stack with heading icon with paw and a text saying Paw Rescue
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.pets,
                size: 32,
              ),
              Text(
                'Paw Rescue',
                style: TextStyle(fontSize: 32),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // const IconAndDetail(Icons.calendar_today, 'October 30'),
          // const IconAndDetail(Icons.location_city, 'San Francisco'),
          // Add from here
          Consumer<ApplicationState>(
            builder: (context, appState, _) => AuthFunc(
                loggedIn: appState.loggedIn,
                signOut: () {
                  FirebaseAuth.instance.signOut();
                }),
          ),
          // to here
          const Divider(
            height: 8,
            thickness: 1,
            indent: 8,
            endIndent: 8,
            color: Colors.grey,
          ),
          // const Header("What we'll be doing"),
          // const Paragraph(
          //   'Join us for a day full of Firebase Workshops and Pizza!',
          // ),
          // const Header("What we'll be doing"),
          // const Paragraph(
          //   'Join us for a day full of Firebase Workshops and Pizza!',
          // ),
          // Consumer<ApplicationState>(
          //   builder: (context, appState, _) => Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       if (appState.loggedIn) ...[
          //         const Header('Discussion'),
          //         GuestBook(
          //           addMessage: (message) =>
          //               appState.addMessageToGuestBook(message),
          //           messages: appState.guestBookMessages,
          //         ),
          //       ],
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}