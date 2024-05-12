import 'package:firebase_ui_auth/firebase_ui_auth.dart'; // new
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // new
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart'; // new

import 'app_state.dart'; // new
import 'home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(ChangeNotifierProvider(
    create: (context) => ApplicationState(),
    builder: ((context, child) => const App()),
  ));
}

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');
// // Add GoRouter configuration outside the App class
final _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  routes: <RouteBase>[
    ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return ScaffoldWithNavBar(child: child);
        },
        routes: <RouteBase>[
          GoRoute(
              path: '/',
              builder: (context, state) => const HomePage(),
              routes: <RouteBase>[
                GoRoute(
                  path: 'sign-in',
                  builder: (context, state) {
                    return SignInScreen(
                      actions: [
                        ForgotPasswordAction(((context, email) {
                          final uri = Uri(
                            path: '/sign-in/forgot-password',
                            queryParameters: <String, String?>{
                              'email': email,
                            },
                          );
                          context.push(uri.toString());
                        })),
                        AuthStateChangeAction(((context, state) {
                          final user = switch (state) {
                            SignedIn state => state.user,
                            UserCreated state => state.credential.user,
                            _ => null
                          };
                          if (user == null) {
                            return;
                          }
                          if (state is UserCreated) {
                            user.updateDisplayName(user.email!.split('@')[0]);
                          }
                          if (!user.emailVerified) {
                            user.sendEmailVerification();
                            const snackBar = SnackBar(
                                content: Text(
                                    'Please check your email to verify your email address'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                          context.pushReplacement('/');
                        })),
                      ],
                    );
                  },
                  routes: [
                    GoRoute(
                      path: 'forgot-password',
                      builder: (context, state) {
                        final arguments = state.uri.queryParameters;
                        return ForgotPasswordScreen(
                          email: arguments['email'],
                          headerMaxExtent: 200,
                        );
                      },
                    ),
                  ],
                ),
                GoRoute(
                  path: 'profile',
                  builder: (context, state) {
                    return ProfileScreen(
                      providers: const [],
                      actions: [
                        SignedOutAction((context) {
                          context.pushReplacement('/');
                        }),
                      ],
                    );
                  },
                ),
              ]),
        ])
  ],
);
// end of GoRouter configuration

// Change MaterialApp to MaterialApp.router and add the routerConfig
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Paw Rescue',
      theme: ThemeData(
        buttonTheme: Theme.of(context).buttonTheme.copyWith(
              highlightColor: Colors.deepPurple,
            ),
        primarySwatch: Colors.deepPurple,
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      routerConfig: _router, // new
    );
  }
}

/// Builds the "shell" for the app by building a Scaffold with a
/// BottomNavigationBar, where [child] is placed in the body of the Scaffold.
class ScaffoldWithNavBar extends StatelessWidget {
  /// Constructs an [ScaffoldWithNavBar].
  const ScaffoldWithNavBar({
    required this.child,
    super.key,
  });

  /// The widget to display in the body of the Scaffold.
  /// In this sample, it is a Navigator.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notification_important_rounded),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Profile',
          ),
        ],
        currentIndex: _calculateSelectedIndex(context),
        onTap: (int idx) => _onItemTapped(idx, context),
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/')) {
      return 0;
    }
    if (location.startsWith('/profile')) {
      return 1;
    }
    if (location.startsWith('/reports')) {
      return 2;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        //navigate to home
        context.pushReplacement('/');
        break;
      case 1:
        //navigate to profile if signed in else navigate to sign-in
        final state = context.read<ApplicationState>();
        if (state.loggedIn == false) {
          context.push('/sign-in');
        } else {
          context.push('/profile');
        }
        break;
      // case 2:
      //   GoRouter.of(context).go('/c');
    }
  }
}
