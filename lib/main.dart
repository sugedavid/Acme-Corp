import 'package:acme_corp/firebase_options.dart';
import 'package:acme_corp/presentation/Home/HomePage.dart';
import 'package:acme_corp/presentation/Login/LoginPage.dart';
import 'package:acme_corp/presentation/Register/RegisterPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'domain/strings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: _buildTheme(Brightness.light),
      home: const LoginPage(),
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => const LoginPage(),
        '/register': (BuildContext context) => const RegisterPage(),
        '/home': (BuildContext context) => const HomePage(),
      },
    );
  }

  ThemeData _buildTheme(brightness) {
    var baseTheme =
        ThemeData(brightness: brightness, primarySwatch: Colors.blue);

    return baseTheme.copyWith(
      textTheme: GoogleFonts.nunitoTextTheme(baseTheme.textTheme),
    );
  }
}
