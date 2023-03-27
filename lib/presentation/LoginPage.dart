import 'package:acme_corp/domain/strings.dart';
import 'package:acme_corp/presentation/shared/colors.dart';
import 'package:acme_corp/presentation/shared/components/Login/LoginForm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage();

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          loginText,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
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
