import 'package:acme_corp/core/services.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CreateTicketForm extends StatefulWidget {
  const CreateTicketForm({Key? key}) : super(key: key);

  @override
  State<CreateTicketForm> createState() => _CreateTicketFormState();
}

class _CreateTicketFormState extends State<CreateTicketForm> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    bool showLoader = false;

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
            const SizedBox(height: 15),

            // Title
            TextFormField(
              controller: titleController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(
                  fontSize: 15,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Title is invalid';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),

            // Description
            TextFormField(
              controller: descriptionController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(
                  fontSize: 15,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Description is invalid';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 40,
            ),

            // create ticket
            Container(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  // validate form
                  if (formKey.currentState!.validate()) {
                    pickFile(context, titleController.text,
                        descriptionController.text, _toggleVisibility);
                  }
                },
                child: showLoader
                    ? LoadingAnimationWidget.beat(
                        color: Colors.white,
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

Future<void> showCreateTicket(context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Create Ticket',
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
        content: const CreateTicketForm(),
      );
    },
  );
}
