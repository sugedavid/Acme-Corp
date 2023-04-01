import 'package:acme_corp/firebase_options.dart';
import 'package:acme_corp/presentation/Home/HomePage.dart';
import 'package:acme_corp/presentation/Home/TicketDetailPage.dart';
import 'package:acme_corp/presentation/Login/LoginPage.dart';
import 'package:acme_corp/presentation/Register/RegisterPage.dart';
import 'package:acme_corp/presentation/shared/color_schemes.g.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io' show Platform;

import 'domain/strings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    if (Platform.isAndroid) {
      // Android-specific code
      await Firebase.initializeApp(
        name: appName,
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } else {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  }

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
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
        textTheme: GoogleFonts.nunitoTextTheme(),
      ),
      home: const HomePage(),
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => const LoginPage(),
        '/register': (BuildContext context) => const RegisterPage(),
        '/home': (BuildContext context) => const HomePage(),
        '/ticket_detail': (BuildContext context) => const TicketDetailPage(),
      },
    );
  }
}
