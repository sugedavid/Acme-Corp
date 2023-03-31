import 'package:acme_corp/core/utils.dart';
import 'package:acme_corp/domain/strings.dart';
import 'package:acme_corp/presentation/Home/components/CreateTicketForm.dart';
import 'package:acme_corp/presentation/Home/components/DrawerMenu.dart';
import 'package:acme_corp/presentation/Home/components/TicketsFragment.dart';
import 'package:acme_corp/presentation/shared/color_schemes.g.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      }
    });
    var navIndex = ref.watch(navProvider);

    final fragmentPages = <Widget>[
      const Center(child: Text('Dashboard')),
      const TicketsFragment(),
    ];

    final screenWidth = MediaQuery.of(context).size.width;
    const breakpoint = 600.0;
    if (screenWidth >= breakpoint) {
      // widescreen: menu on the left, content on the right
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const Text(
            appName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          backgroundColor: lightColorScheme.primary,
        ),
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
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => showCreateTicket(context),
          label: const Text('Create ticket'),
        ),
      );
    } else {
      // mobile view
      return Scaffold(
        appBar: AppBar(elevation: 0, title: const Text(appName)),
        body: fragmentPages[navIndex],
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => showCreateTicket(context),
          label: const Text('Create ticket'),
        ),
        drawer: const Drawer(child: DrawerMenu()),
      );
    }
  }
}

// create ticket dialog
