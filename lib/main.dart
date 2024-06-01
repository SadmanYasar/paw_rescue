import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:paw_rescue/firebase_options.dart';
import 'package:paw_rescue/services/adoption_data_service.dart';
import 'package:paw_rescue/services/animal_data_service.dart';
import 'package:provider/provider.dart'; // new
import 'package:paw_rescue/screens/router.dart'; // new
import 'services/reports_data_service.dart';
import 'widgets/app_state.dart'; // new
import 'package:json_theme/json_theme.dart';
import 'package:flutter/services.dart'; // For rootBundle
import 'dart:convert'; // For jsonDecode

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeStr = await rootBundle.loadString('assets/appainter_theme.json');
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson)!;

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ApplicationState(),
        ),
        ChangeNotifierProvider(
          create: (context) => ReportService(),
        ),
        ChangeNotifierProvider(
          create: (context) => AnimalService(),
        ),
        ChangeNotifierProvider(
          create: (context) => AdoptionService(),
        ),
      ],
      child: App(
        theme: theme,
      ),
    ),
  );
}

// Change MaterialApp to MaterialApp.router and add the routerConfig
class App extends StatelessWidget {
  final ThemeData theme;
  const App({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Paw Rescue',
      // themeMode: ThemeMode.system,
      theme: theme,
      // darkTheme: ThemeData.dark(
      //   useMaterial3: true,
      // ),
      routerConfig: router, // new
    );
  }
}
