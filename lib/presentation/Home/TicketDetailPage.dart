import 'package:acme_corp/core/services.dart';
import 'package:acme_corp/core/utils.dart';
import 'package:acme_corp/presentation/Home/components/TicketDrawerMenu.dart';
import 'package:acme_corp/presentation/shared/color_schemes.g.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class TicketDetailPage extends ConsumerWidget {
  final dynamic ticket;

  const TicketDetailPage({Key? key, this.ticket}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String createdAt = DateFormat.MMMEd()
        .add_jm()
        .format(DateTime.parse(ticket?['createdAt']));

    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    Map ticketInfo = <dynamic, dynamic>{};

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Ticket Info',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        backgroundColor: lightColorScheme.primary,
        actions: <Widget>[
          Container(),
        ],
      ),
      endDrawer: const Drawer(child: TicketDrawerMenu()),
      body: StreamBuilder<Object>(
          stream:
              FirebaseDatabase.instance.ref('tickets/${ticket?['id']}').onValue,
          builder: (context, snapshot) {
            // loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: LoadingAnimationWidget.beat(
                color: Colors.white,
                size: 18,
              ));
            }

            if (snapshot.hasData &&
                snapshot.data != null &&
                (snapshot.data! as DatabaseEvent).snapshot.value != null) {
              ticketInfo = Map<dynamic, dynamic>.from(
                  (snapshot.data! as DatabaseEvent).snapshot.value
                      as Map<dynamic, dynamic>);
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // ticket info

                  Card(
                    margin: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                    color: Colors.white,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(10),
                      title: Text(ticketInfo['title']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ticketInfo['description'],
                            style: const TextStyle(fontSize: 12),
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(height: 10),
                          Chip(
                              backgroundColor:
                                  statusColor(ticketInfo['status']) ??
                                      Colors.purple[100],
                              label: Text(
                                ticketInfo['status'],
                                style: const TextStyle(fontSize: 8),
                              )),
                        ],
                      ),
                      trailing: Text(
                        createdAt,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  // agent & customer info

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // customer
                        Column(
                          children: [
                            Text('Customer:',
                                style: TextStyle(
                                  color: lightColorScheme.primary,
                                )),
                            FutureBuilder(
                                future:
                                    getUserInfo(ticketInfo['customer'], 'name'),
                                builder: (context, snapshot) {
                                  return Text(snapshot.data.toString());
                                }),
                            FutureBuilder(
                                future: getUserInfo(
                                    ticketInfo['customer'], 'email'),
                                builder: (context, snapshot) {
                                  return Text(snapshot.data.toString());
                                }),
                          ],
                        ),
                        const SizedBox(width: 10),
                        // agent
                        Column(
                          children: [
                            Text('Agent:',
                                style: TextStyle(
                                  color: lightColorScheme.primary,
                                )),
                            FutureBuilder(
                                future:
                                    getUserInfo(ticketInfo['agent'], 'name'),
                                builder: (context, snapshot) {
                                  return Text(snapshot.data.toString());
                                }),
                            FutureBuilder(
                                future:
                                    getUserInfo(ticketInfo['agent'], 'email'),
                                builder: (context, snapshot) {
                                  return Text(snapshot.data.toString());
                                }),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // actions

                  Builder(builder: (context) {
                    return FutureBuilder(
                        future: getUserInfo(userId, 'userType'),
                        builder: (context, snapshot) {
                          return Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              if (snapshot.data.toString() == 'Agent') ...{
                                //assign customer

                                Flexible(
                                  child: OutlinedButton(
                                      onPressed: () {
                                        ref
                                            .read(ticketProvider.notifier)
                                            .state = {
                                          'userType': 'Customer',
                                          'ticketId': ticketInfo['id'],
                                          'customer': ticketInfo['customer']
                                        };

                                        Scaffold.of(context).openEndDrawer();
                                      },
                                      child: const Text('Assign customer')),
                                ),
                                const SizedBox(width: 10),
                                //assign agent
                                Flexible(
                                  child: OutlinedButton(
                                      onPressed: () {
                                        ref
                                            .read(ticketProvider.notifier)
                                            .state = {
                                          'userType': 'Agent',
                                          'ticketId': ticketInfo['id'],
                                          'customer': ticketInfo['customer']
                                        };
                                        Scaffold.of(context).openEndDrawer();
                                      },
                                      child: const Text('Assign agent')),
                                ),
                              },

                              // transistion
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 20),
                                  child: DropdownButton(
                                    // isExpanded: true,
                                    value: ticketInfo['status'],
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    items: transitions.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(
                                          items,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      transitionTicket(
                                          context, ticketInfo['id'], value);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          );
                        });
                  }),

                  const SizedBox(height: 20),
                ],
              ),
            );
          }),
    );
  }
}
