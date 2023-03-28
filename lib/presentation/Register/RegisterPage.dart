import 'package:acme_corp/presentation/Register/RegisterForm.dart';
import 'package:acme_corp/presentation/shared/colors.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Register',
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
                          child: RegisterForm(),
                        ),
                      )))
              : const RegisterForm(),
        ),
      ),
    );
  }
}
