import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

// set user info to db
Future<void> saveUserInfo(
    context, userId, name, userType, email, toggleVisibility) async {
  DatabaseReference ref = FirebaseDatabase.instance.ref('users/$userId');

  await ref.set({
    "name": name,
    "userType": userType,
    "email": email,
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
