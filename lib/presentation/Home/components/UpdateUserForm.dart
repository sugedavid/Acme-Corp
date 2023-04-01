import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:acme_corp/core/services.dart';
import 'package:acme_corp/presentation/shared/color_schemes.g.dart';

class UpdateUserForm extends StatefulWidget {
  final String userId;
  const UpdateUserForm({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<UpdateUserForm> createState() => _UpdateUserFormState();
}

class _UpdateUserFormState extends State<UpdateUserForm> {
  bool showLoader = false;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final nameTextController = TextEditingController();

    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
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

            // create ticket
            Container(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  // validate form
                  if (formKey.currentState!.validate()) {
                    updateUserProfile(
                            context, widget.userId, nameTextController.text)
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

Future<void> showUpdateCustomer(context, userId) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Edit Customer Profile',
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
        content: UpdateUserForm(
          userId: userId,
        ),
      );
    },
  );
}
