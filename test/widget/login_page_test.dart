import 'package:acme_corp/presentation/Login/LoginForm.dart';
import 'package:acme_corp/presentation/Login/LoginPage.dart';
import 'package:acme_corp/presentation/Register/RegisterPage.dart';
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

    testWidgets('should navigate to registration page',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const LoginPage(),
          routes: {
            '/register': (_) => const Scaffold(body: RegisterPage()),
          },
        ),
      );

      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();

      expect(find.byType(RegisterPage), findsOneWidget);
    });
  });
}
