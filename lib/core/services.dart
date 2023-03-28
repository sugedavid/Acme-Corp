import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

// upload file and create ticket
Future<void> pickFile(context, title, description, toggleVisibility) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['jpg', 'pdf', 'png'],
  );

  if (result != null) {
    Uint8List? fileBytes = result.files.first.bytes;
    String fileName = result.files.first.name;

    // Upload file to storage
    if (fileBytes != null) {
      final storageRef = FirebaseStorage.instance.ref('uploads/$fileName');

      await storageRef.putData(fileBytes).then((snapshot) async {
        toggleVisibility();
        DatabaseReference ref = FirebaseDatabase.instance.ref('tickets');
        String url = await storageRef.getDownloadURL();
        await ref.push().set({
          "title": title,
          "description": description,
          "fileUrl": url,
          'status': 'Pending',
          'createdBy': FirebaseAuth.instance.currentUser?.uid,
          'createdAt': DateTime.now().toString()
        }).then((_) {
          // save to db
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Ticket created sucessfully."),
          ));
          Navigator.of(context).pop();
        }).catchError((error) {
          // The db write failed
          toggleVisibility();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(error),
          ));
        });
      }).catchError((error) {
        // The storage upload failed
        toggleVisibility();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error),
        ));
      });
    }
  } else {
    // User canceled the picker
  }
}

// set user info to db
Future<void> saveUserInfo(
    context, userId, name, userType, email, toggleVisibility) async {
  DatabaseReference ref = FirebaseDatabase.instance.ref('users/$userId');

  await ref.set({
    "name": name,
    "userType": userType,
    "email": email,
    'userId': userId,
  }).then((_) {
    toggleVisibility();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content:
          Text("Account registered successfully! Login with your new account."),
    ));
    Navigator.of(context).pop();
  }).catchError((error) {
    // The write failed...
    toggleVisibility();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(error),
    ));
  });
}

// user account creation
Future<void> createUserAccount(
    context, name, userType, emailAddress, password, toggleVisibility) async {
  try {
    toggleVisibility();

    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: emailAddress,
      password: password,
    )
        .then((value) {
      saveUserInfo(context, value.user?.uid, name, userType, emailAddress,
          toggleVisibility);
    });
  } on FirebaseAuthException catch (e) {
    toggleVisibility();
    if (e.code == 'weak-password') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("The password provided is too weak."),
      ));
    } else if (e.code == 'email-already-in-use') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("The account already exists for that email"),
      ));
    }
  } catch (e) {
    toggleVisibility();
    String error = e.toString();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(error),
    ));
  }
}

// user login
Future<void> loginUser(
    context, emailAddress, password, toggleVisibility) async {
  try {
    toggleVisibility();
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: emailAddress,
      password: password,
    )
        .then((value) {
      toggleVisibility();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Logged in successfully."),
      ));
      Navigator.pushNamed(context, '/home');
    });
  } on FirebaseAuthException catch (e) {
    toggleVisibility();
    if (e.code == 'user-not-found') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("No user found for that email."),
      ));
    } else if (e.code == 'wrong-password') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Wrong password provided for that user."),
      ));
    }
  } catch (e) {
    toggleVisibility();
    String error = e.toString();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(error),
    ));
  }
}

// log user out
void logOutUser(context) {
  FirebaseAuth.instance.signOut().then((value) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Logged out successfully."),
    ));
    // Navigator.pushReplacementNamed(context, '/');
  });
}

Object getUserInfo(userId) {
  Object data = {};
  DatabaseReference userRef = FirebaseDatabase.instance.ref('user/$userId');
  userRef.onValue.listen((DatabaseEvent event) {
    data = event.snapshot.value ?? {};
  });

  return data;
}
