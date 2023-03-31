import 'package:acme_corp/core/services.dart';
import 'package:acme_corp/core/utils.dart';
import 'package:acme_corp/presentation/shared/color_schemes.g.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class DrawerMenu extends ConsumerWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var navIndex = ref.watch(navProvider);

    final screenWidth = MediaQuery.of(context).size.width;
    const breakpoint = 600.0;

    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    Map userInfo = <dynamic, dynamic>{};

    String userType = '';
    List drawerItems = navItems;

    getUserInfo(userId, 'userType').then((String result) {
      userType = result;
      drawerItems = userType == 'Agent' ? navItems : customerItems;
    });

    return StreamBuilder<Object>(
        stream: FirebaseDatabase.instance.ref('users/$userId').onValue,
        builder: (context, snapshot) {
          // loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: LoadingAnimationWidget.beat(
              color: lightColorScheme.primary,
              size: 18,
            ));
          }
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // user name
                  Text(
                    userInfo['name'] ?? 'No name',
                    style: const TextStyle(fontSize: 14),
                  ),

                  // email
                  Text(
                    FirebaseAuth.instance.currentUser?.email ?? 'No email',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 10),

                  // user type
                  Chip(
                      backgroundColor: userInfo['userType'] == 'Agent'
                          ? Colors.purple[100]
                          : Colors.orange[100],
                      label: Text(
                        userInfo['userType'] ?? 'No type',
                        style: const TextStyle(fontSize: 12),
                      ))
                ],
              ),
            ),

            // drawer items
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: drawerItems.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: drawerItems[index]['icon'],
                    title: drawerItems[index]['title'],
                    selected: index == navIndex,
                    onTap: () {
                      if (index != drawerItems.length - 1) {
                        ref.read(navProvider.notifier).state = index;
                      }
                      if (index == drawerItems.length - 1) {
                        logOutUser(context);
                      }
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
