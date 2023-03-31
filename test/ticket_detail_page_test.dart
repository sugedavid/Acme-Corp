// import 'package:acme_corp/presentation/Home/TicketDetailPage.dart';
// import 'package:acme_corp/presentation/Register/RegisterForm.dart';
// import 'package:acme_corp/presentation/Register/RegisterPage.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';

// import 'mock.dart';

// void main() {
//   setupFirebaseAuthMocks();

//   setUpAll(() async {
//     await Firebase.initializeApp();
//   });
//   group('TicketDetailPage', () {
//     setUp(() {});

//     testWidgets('displays register form', (WidgetTester tester) async {
//       await tester.pumpWidget(
//         const MaterialApp(
//           home: TicketDetailPage(),
//         ),
//       );
//       await tester.pumpAndSettle();
//       expect(find.text('Ticket Info'), findsOneWidget);
//     });
//   });
// }
