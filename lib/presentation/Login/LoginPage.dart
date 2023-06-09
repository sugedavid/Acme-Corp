import 'package:acme_corp/domain/strings.dart';
import 'package:acme_corp/presentation/Login/LoginForm.dart';
import 'package:acme_corp/presentation/shared/color_schemes.g.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    // check if user is logged in
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        Navigator.pushNamed(context, '/home');
      }
    });

    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          loginText,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        backgroundColor: lightColorScheme.primary,
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: width >= 500
              ? const Center(
                  child: SizedBox(
                      width: 400,
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(38.0),
                          child: LoginForm(),
                        ),
                      )))
              : const LoginForm(),
        ),
      ),
    );
  }
}
