import 'package:acme_corp/core/utils.dart';
import 'package:acme_corp/domain/strings.dart';
import 'package:acme_corp/presentation/Home/component/DrawerMenu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var navIndex = ref.watch(navProvider);
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
      }
    });

    final fragmentPages = <Widget>[
      const Center(child: Text('Dashboard')),
      const Center(child: Text('Tickets')),
    ];

    final screenWidth = MediaQuery.of(context).size.width;
    const breakpoint = 600.0;
    if (screenWidth >= breakpoint) {
      // widescreen: menu on the left, content on the right
      return Scaffold(
        body: Row(
          children: [
            const SizedBox(
              width: 240,
              child: DrawerMenu(),
            ),
            Container(width: 0.4, color: Colors.grey),
            Expanded(child: fragmentPages[navIndex]),
          ],
        ),
      );
    } else {
      // mobile view
      return Scaffold(
        appBar: AppBar(title: const Text(appName)),
        body: fragmentPages[navIndex],
        drawer: const Drawer(child: DrawerMenu()),
      );
    }
  }
}
