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

    testWidgets('should pop registration page', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: RegisterPage(),
        ),
      );

      await tester.drag(
          find.text('Please fill in the details below to register.'),
          const Offset(0.0, -600));
      await tester.pump();
      await tester.pumpAndSettle();
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();

      expect(find.byType(RegisterPage), findsNothing);
    });
  });
}
