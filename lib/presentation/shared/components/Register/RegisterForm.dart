import 'dart:async';

import 'package:acme_corp/core/services.dart';
import 'package:acme_corp/domain/strings.dart';
import 'package:acme_corp/presentation/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({
    Key? key,
  }) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  bool showLoader = false;
  late Timer _timer;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int _start = 2;

    void startTimer() {
      showLoader = true;
      const oneSec = Duration(seconds: 1);

      _timer = Timer.periodic(
        oneSec,
        (Timer timer) {
          if (_start == 0) {
            showLoader = false;
            setState(() {
              timer.cancel();
            });
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(builder: (context) => const HomePage()),
            // );
          } else {
            setState(() {
              _start--;
            });
          }
        },
      );
    }

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 15,
            ),
            const Text(
              loginTitle,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              loginBody,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            // Email
            TextFormField(
              controller: _emailTextController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: emailText,
                labelStyle: TextStyle(
                  fontSize: 15,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email is invalid';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),

            // Password
            TextFormField(
              controller: _passwordTextController,
              keyboardType: TextInputType.visiblePassword,
              decoration: const InputDecoration(
                labelText: passwordText,
                labelStyle: TextStyle(
                  fontSize: 15,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email is invalid';
                } else if (value.length < 6) {
                  return 'Password must be at least six characters';
                } else {
                  return null;
                }
              },
              obscureText: true,
            ),
            const SizedBox(
              height: 40,
            ),

            // Log In
            SizedBox(
              width: double.infinity,
              height: 45,
              child: TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: AppColors.primaryColor,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                ),
                onPressed: () {
                  // validate form
                  if (_formKey.currentState!.validate()) {
                    setState(() {});
                    createUserAccount(context, _emailTextController.text,
                        _passwordTextController.text, showLoader);
                  }
                },
                child: (showLoader == true)
                    ? Center(
                        child: LoadingAnimationWidget.beat(
                          color: Colors.white,
                          size: 24,
                        ),
                      )
                    : Text(
                        loginText.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            // Forgot Password
            const Center(
              child: Text(
                forgotPasswordText,
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
