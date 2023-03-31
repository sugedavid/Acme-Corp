import 'package:acme_corp/presentation/Register/RegisterForm.dart';
import 'package:acme_corp/presentation/Register/RegisterPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock.dart';

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });
  group('RegisterPage', () {
    setUp(() {});

    testWidgets('displays register form', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: RegisterPage(),
        ),
      );

      expect(find.text('REGISTER'), findsOneWidget);
      expect(find.byType(RegisterForm), findsOneWidget);
    });
  });
}
