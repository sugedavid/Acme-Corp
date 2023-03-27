import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> createUserAccount(
    context, emailAddress, password, showLoader) async {
  try {
    showLoader == true;
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );
  } on FirebaseAuthException catch (e) {
    showLoader == false;
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
    showLoader == false;
    String error = e.toString();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(error),
    ));
  }
}

Future<void> loginUser(
    context, emailAddress, password, toggleVisibility) async {
  try {
    toggleVisibility();
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );
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
