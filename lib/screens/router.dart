/* 
=============================================
Contains the GoRouter configuration
=============================================
*/

import 'package:firebase_ui_auth/firebase_ui_auth.dart'; // new
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // new
import 'package:paw_rescue/screens/reports_page.dart';

import 'package:paw_rescue/screens/home_page.dart';
import 'package:paw_rescue/widgets/widgets.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

final router = GoRouter(
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
                  path: 'reports',
                  builder: (context, state) {
                    return ReportsPage();
                  },
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
