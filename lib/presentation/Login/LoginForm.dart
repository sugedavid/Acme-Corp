import 'package:acme_corp/core/services.dart';
import 'package:acme_corp/domain/strings.dart';
import 'package:acme_corp/presentation/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  bool showLoader = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void _toggleVisibility() {
      setState(() {
        showLoader = !showLoader;
      });
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
                  return 'Password is invalid';
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
            Container(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  // validate form
                  if (_formKey.currentState!.validate()) {
                    loginUser(context, _emailTextController.text,
                        _passwordTextController.text, _toggleVisibility);
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: AppColors.primaryColorAccent,
                ),
                child: showLoader
                    ? LoadingAnimationWidget.beat(
                        color: Colors.white,
                        size: 18,
                      )
                    : const Text('LOG IN'),
              ),
            ),
            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Register
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text(
                    'Register account',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 14,
                    ),
                  ),
                ),

                // Forgot Password
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Forgot password',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
