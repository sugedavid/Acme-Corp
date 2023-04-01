import 'dart:math';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

// send message
Future<void> sendMessage(
    context, ticketId, message, senderId, senderName) async {
  DatabaseReference ref =
      FirebaseDatabase.instance.ref('tickets/$ticketId/conversations/').push();

  await ref
      .set({
        'messageId': ref.key,
        'message': message,
        'senderId': senderId,
        'senderName': senderName,
        'time': DateTime.now().toString(),
      })
      .then((_) {})
      .catchError((error) {
        // The write failed...
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error),
        ));
      });
}

// update user profile
Future<void> updateUserProfile(context, userId, name) async {
  DatabaseReference ref = FirebaseDatabase.instance.ref('users/$userId');

  await ref.update({
    'name': name,
  }).then((_) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Customer updated successfully.'),
    ));
    Navigator.of(context).pop();
  }).catchError((error) {
    // The write failed...
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(error),
    ));
  });
}

// create customer profile
Future<void> createCustomerProfile(
    context, name, email, toggleVisibility) async {
  DatabaseReference ref = FirebaseDatabase.instance.ref('users').push();

  await ref.set({
    'name': name,
    'userType': 'Customer',
    'email': email,
    'userId': ref.key,
  }).then((_) {
    toggleVisibility();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Customer profile created successfully.'),
    ));
  }).catchError((error) {
    // The write failed...
    toggleVisibility();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(error),
    ));
  });
}

//get user info
Future<String> getUserInfo(userId, child) async {
  final userRef = FirebaseDatabase.instance.ref();
  final snapshot = await userRef.child('users/$userId').get();

  if (snapshot.child(child).value != null &&
      snapshot.child(child).value != '') {
    return snapshot.child(child).value.toString();
  }
  return '-';
}

// assign agent
Future<void> assignAgent(context, ticketId, agentId) async {
  DatabaseReference ref = FirebaseDatabase.instance.ref('tickets/$ticketId');

  await ref.update({
    'agent': agentId,
  }).then((_) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Agent assigned successfully.'),
    ));
    Navigator.of(context).pop();
  }).catchError((error) {
    // The write failed...
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(error),
    ));
  });
}

// assign customer
Future<void> assignCustomer(context, ticketId, customerId) async {
  DatabaseReference ref = FirebaseDatabase.instance.ref('tickets/$ticketId');

  await ref.update({
    'customer': customerId,
  }).then((_) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Customer assigned successfully.'),
    ));
    Navigator.of(context).pop();
  }).catchError((error) {
    // The write failed...
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(error),
    ));
  });
}

// transition ticket
Future<void> transitionTicket(context, ticketId, transition) async {
  DatabaseReference ref = FirebaseDatabase.instance.ref('tickets/$ticketId');

  await ref.update({
    'status': transition,
  }).then((_) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Ticket transitioned successfully.'),
    ));
    // Navigator.of(context).pop();
  }).catchError((error) {
    // The write failed...
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(error),
    ));
  });
}

// create ticket
Future<void> createTicket(
    context, title, description, url, toggleVisibility) async {
  // save to db
  toggleVisibility();
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  final userRef = FirebaseDatabase.instance.ref();
  final snapshot = await userRef.child('users/$userId').get();

  String customer = (snapshot.child('userType').value.toString() == 'Customer')
      ? snapshot.child('userId').value.toString()
      : '';

  String agent = (snapshot.child('userType').value.toString() == 'Agent')
      ? snapshot.child('userId').value.toString()
      : '';
  DatabaseReference ref = FirebaseDatabase.instance.ref('tickets').push();
  await ref.set({
    'id': ref.key,
    'ticketNo': '#${Random().nextInt(1000)}',
    'title': title,
    'description': description,
    'fileUrl': url,
    'status': 'OPEN',
    'agent': agent,
    'customer': customer,
    'createdBy': FirebaseAuth.instance.currentUser?.uid,
    'createdAt': DateTime.now().toString()
  }).then((_) {
    // success
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Ticket created sucessfully.'),
    ));
    Navigator.of(context).pop();
  }).catchError((error) {
    // The db write failed
    toggleVisibility();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(error),
    ));
  });
}

// upload file and create ticket
Future<void> pickFile(context, toggleVisibility, uploadFile) async {
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
        uploadFile(storageRef.getDownloadURL(), fileName);

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('File uploaded sucessfully.'),
        ));
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
    uploadFile('', 'No file uploaded');
  }
}

// set user info to db
Future<void> saveUserInfo(
    context, userId, name, userType, email, toggleVisibility) async {
  DatabaseReference ref = FirebaseDatabase.instance.ref('users/$userId');

  await ref.set({
    'name': name,
    'userType': userType,
    'email': email,
    'userId': userId,
  }).then((_) {
    toggleVisibility();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Account registered successfully.'),
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
        content: Text('The password provided is too weak.'),
      ));
    } else if (e.code == 'email-already-in-use') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('The account already exists for that email'),
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

      Navigator.of(context)
          .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false)
          .then((value) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Logged in successfully.'),
        ));
      });
    });
  } on FirebaseAuthException catch (e) {
    toggleVisibility();
    if (e.code == 'user-not-found') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No user found for that email.'),
      ));
    } else if (e.code == 'wrong-password') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Wrong password provided for that user.'),
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
void logOutUser(context) async {
  FirebaseAuth.instance.signOut().then((value) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Logged out successfully.'),
    ));
  });
}
