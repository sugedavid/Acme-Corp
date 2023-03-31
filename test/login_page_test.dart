import 'package:acme_corp/presentation/Login/LoginForm.dart';
import 'package:acme_corp/presentation/Login/LoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'mock.dart';

class MockUserCredential extends Mock implements UserCredential {}

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });
  group('LoginPage', () {
    setUp(() {});

    // testWidgets('redirects to home page when user is logged in',
    //     (WidgetTester tester) async {
    //   // Create a mock FirebaseAuth instance
    //   final auth = MockFirebaseAuth();

    //   // Create a mock user with the email and password
    //   const email = 'test@example.com';
    //   const password = 'password';
    //   final mockUser = MockUser(
    //     isAnonymous: false,
    //     uid: '12345',
    //     email: email,
    //   );

    //   // Set up the mock to return the mockUser when signInWithEmailAndPassword is called
    //   when(auth.signInWithEmailAndPassword(email: email, password: password))
    //       .thenAnswer((_) => Future.value(MockUserCredential()));

    //   // Call signInWithEmailAndPassword and wait for it to complete
    //   final userCredential = await auth.signInWithEmailAndPassword(
    //       email: email, password: password);

    //   // Check that the returned userCredential contains the mockUser
    //   expect(userCredential.user, equals(mockUser));

    //   await tester.pumpWidget(
    //     MaterialApp(
    //       home: const LoginPage(),
    //       routes: {
    //         '/home': (_) => const Scaffold(body: Text('Home page')),
    //       },
    //     ),
    //   );

    //   // Ensure LoginPage is not displayed
    //   expect(find.byType(LoginPage), findsNothing);

    //   // Ensure Home page is displayed
    //   expect(find.text('Home page'), findsOneWidget);
    // });

    testWidgets('displays login form when user is not logged in',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginPage(),
        ),
      );

      // Ensure LoginPage is displayed
      expect(find.text('LOG IN'), findsOneWidget);

      // Ensure login form is displayed
      expect(find.byType(LoginForm), findsOneWidget);
    });
  });
}
