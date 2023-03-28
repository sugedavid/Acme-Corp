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
  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  String _userType = 'Customer';
  // List of items in our dropdown menu
  var items = [
    'Customer',
    'Agent',
  ];

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
              'Welcome to Acme Corp',
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
              'Please fill in the details below to register.',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            // name
            TextFormField(
              controller: _nameTextController,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                labelText: 'First and last name',
                labelStyle: TextStyle(
                  fontSize: 15,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Name is invalid';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),

            // user type
            DropdownButton(
              isExpanded: true,
              value: _userType,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: items.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _userType = newValue!;
                });
              },
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

            // Register
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Log in
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Log in',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 14,
                    ),
                  ),
                ),

                // register
                ElevatedButton(
                  onPressed: () {
                    // validate form
                    if (_formKey.currentState!.validate()) {
                      createUserAccount(
                          context,
                          _nameTextController.text,
                          _userType,
                          _emailTextController.text,
                          _passwordTextController.text,
                          _toggleVisibility);
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
                      : const Text('REGISTER'),
                ),
              ],
            ),

            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
