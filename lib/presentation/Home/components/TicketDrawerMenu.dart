import 'package:acme_corp/core/services.dart';
import 'package:acme_corp/core/utils.dart';
import 'package:acme_corp/presentation/Home/components/UpdateUserForm.dart';
import 'package:acme_corp/presentation/shared/color_schemes.g.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class TicketDrawerMenu extends ConsumerWidget {
  const TicketDrawerMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var users = <dynamic>[];

    var ticketInfo = ref.watch(ticketProvider);

    return StreamBuilder<Object>(
        stream: FirebaseDatabase.instance.ref('users').onValue,
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
            var usersSnapshot = Map<dynamic, dynamic>.from(
                (snapshot.data! as DatabaseEvent).snapshot.value
                    as Map<dynamic, dynamic>);

            users.clear();
            usersSnapshot.forEach((key, value) {
              if (value['userType'] == ticketInfo['userType']) {
                users.add(value);
              }
            });

            if (users.isEmpty) {
              return Center(
                child: Text('No ${ticketInfo['userType']}s'),
              );
            }

            return ListView(padding: const EdgeInsets.all(8.0), children: [
              // title
              Text(
                '${ticketInfo['userType']}s',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // users
              ListView.builder(
                shrinkWrap: true,
                itemCount: users.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),

                      Row(
                        children: [
                          const Icon(
                            Icons.account_circle_outlined,
                            size: 24,
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                users[index]['name'] ?? 'No name',
                                style: const TextStyle(fontSize: 12),
                              ),
                              Text(
                                users[index]['email'] ?? 'No email',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      // assign agent
                      Row(
                        children: [
                          TextButton(
                              onPressed: () {
                                ticketInfo['userType'] == 'Customer'
                                    ? assignAgent(
                                        context,
                                        ticketInfo['ticketId'],
                                        users[index]['userId'])
                                    : assignCustomer(
                                        context,
                                        ticketInfo['ticketId'],
                                        users[index]['userId']);
                              },
                              child: const Text(
                                'Assign',
                                style: TextStyle(fontSize: 12),
                              )),
                          const SizedBox(width: 2),
                          TextButton(
                              onPressed: (ticketInfo['userType'] == 'Agent')
                                  ? null
                                  : () {
                                      showUpdateCustomer(
                                          context, ticketInfo['customer']);
                                    },
                              child: const Text(
                                'Edit',
                                style: TextStyle(fontSize: 12),
                              )),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                },
              )
              // agents
            ]);
          }

          return const Center(
            child: Text('No users'),
          );

          // error
          // if (snapshot.hasError) {
          //   return const Center(child: Text('Error loading users'));
          // }

          // return Container();
        });
  }
}
