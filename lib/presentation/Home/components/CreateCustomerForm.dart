import 'package:acme_corp/core/services.dart';
import 'package:acme_corp/presentation/shared/color_schemes.g.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CreateCustomerForm extends StatefulWidget {
  const CreateCustomerForm({Key? key}) : super(key: key);

  @override
  State<CreateCustomerForm> createState() => _CreateCustomerFormState();
}

class _CreateCustomerFormState extends State<CreateCustomerForm> {
  bool showLoader = false;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final nameTextController = TextEditingController();
    final emailTextController = TextEditingController();

    void _toggleVisibility() {
      setState(() {
        showLoader = !showLoader;
      });
    }

    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),

            // name
            TextFormField(
              controller: nameTextController,
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

            // Email
            TextFormField(
              controller: emailTextController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
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

            // create ticket
            Container(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  // validate form
                  if (formKey.currentState!.validate()) {
                    createCustomerProfile(context, nameTextController.text,
                            emailTextController.text, _toggleVisibility)
                        .then((value) => Navigator.pop(context));
                  }
                },
                child: showLoader
                    ? LoadingAnimationWidget.beat(
                        color: lightColorScheme.primary,
                        size: 18,
                      )
                    : const Text('CREATE'),
              ),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

Future<void> showCreateCustomer(context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Customer Profile',
              style: TextStyle(fontSize: 16),
            ),
            IconButton(
                onPressed: (() => Navigator.pop(context)),
                icon: const Icon(
                  Icons.close,
                  size: 20,
                ))
          ],
        ),
        content: const CreateCustomerForm(),
      );
    },
  );
}
