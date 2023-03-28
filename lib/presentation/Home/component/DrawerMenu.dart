import 'package:acme_corp/core/utils.dart';
import 'package:acme_corp/domain/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DrawerMenu extends ConsumerWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var navIndex = ref.watch(navProvider);

    final screenWidth = MediaQuery.of(context).size.width;
    const breakpoint = 600.0;

    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    Map userInfo = <dynamic, dynamic>{};

    return StreamBuilder<Object>(
        stream: FirebaseDatabase.instance.ref('users/$userId').onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.data != null &&
              (snapshot.data! as DatabaseEvent).snapshot.value != null) {
            userInfo = Map<dynamic, dynamic>.from(
                (snapshot.data! as DatabaseEvent).snapshot.value
                    as Map<dynamic, dynamic>);
          }

          return ListView(children: [
            // drawer header
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // app name
                  ListTile(
                      leading: const Image(
                          height: 24,
                          width: 24,
                          image: AssetImage('assets/images/logo.png')),
                      title: const Text(
                        appName,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      onTap: () {}),

                  // user name
                  Text(userInfo['name'] ?? 'No name'),

                  // email
                  Text(FirebaseAuth.instance.currentUser?.email ?? 'No email'),
                  const SizedBox(height: 10),

                  // user type
                  Chip(
                      backgroundColor: userInfo['userType'] == 'Agent'
                          ? Colors.green[100]
                          : Colors.orange[100],
                      label: Text(userInfo['userType'] ?? 'No type'))
                ],
              ),
            ),

            // drawer items
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: navItems.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: navItems[index]['icon'],
                    title: navItems[index]['title'],
                    selected: index == navIndex,
                    onTap: () {
                      ref.read(navProvider.notifier).state = index;
                      if (screenWidth < breakpoint) {
                        Navigator.pop(context);
                      }
                    },
                  );
                },
              ),
            ),
          ]);
        });
  }
}
