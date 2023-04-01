import 'package:acme_corp/core/services.dart';
import 'package:acme_corp/core/utils.dart';
import 'package:acme_corp/presentation/Home/TicketDetailPage.dart';
import 'package:acme_corp/presentation/shared/color_schemes.g.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class TicketsFragment extends StatelessWidget {
  const TicketsFragment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tickets = <dynamic>[];

    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    String userType = '';

    getUserInfo(userId, 'userType').then((String result) {
      userType = result;
    });

    return StreamBuilder(
        stream: FirebaseDatabase.instance.ref('tickets').onValue,
        builder: (context, snapshot) {
          // loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: LoadingAnimationWidget.beat(
              color: lightColorScheme.primary,
              size: 18,
            ));
          }

          // data
          if ((snapshot.hasData &&
              snapshot.data != null &&
              (snapshot.data! as DatabaseEvent).snapshot.value != null)) {
            var ticketsSnapshot = Map<dynamic, dynamic>.from(
                (snapshot.data as DatabaseEvent).snapshot.value
                    as Map<dynamic, dynamic>);

            tickets.clear();
            if (userType == 'Agent') {
              ticketsSnapshot.forEach((key, value) {
                tickets.add(value);
              });
            } else {
              ticketsSnapshot.forEach((key, value) {
                if (value['createdBy'] == userId ||
                    value['customer'] == userId) {
                  tickets.add(value);
                }
              });
            }

            return ListView(
              children: [
                // title
                Container(
                  margin: const EdgeInsets.fromLTRB(80, 20, 0, 0),
                  child: const Text(
                    'Tickets',
                    style: TextStyle(fontSize: 18),
                  ),
                ),

                // tickets
                ListView.builder(
                  shrinkWrap: true,
                  reverse: true,
                  itemCount: tickets.length,
                  itemBuilder: (BuildContext context, int index) {
                    String createdAt = tickets[index]?['createdAt'] != null
                        ? DateFormat.MMMEd().add_jm().format(
                            DateTime.parse(tickets[index]?['createdAt']))
                        : 'No time';
                    return Card(
                      margin: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                      color: Colors.white,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        onTap: (() => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TicketDetailPage(
                                ticket: tickets[index],
                              ),
                            ))),
                        title: Text(
                          tickets[index]?['title'] ?? 'No title',
                          style: const TextStyle(fontSize: 14),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tickets[index]?['description'] ??
                                  'No description',
                              style: const TextStyle(fontSize: 12),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 10),
                            Chip(
                                backgroundColor:
                                    statusColor(tickets[index]?['status']) ??
                                        Colors.purple[100],
                                label: Text(
                                  tickets[index]?['status'] ?? 'No status',
                                  style: const TextStyle(fontSize: 8),
                                )),
                          ],
                        ),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              createdAt,
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Ticket no: ${tickets[index]?['ticketNo']}',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          } else {
            return const Center(
              child: Text('No tickets'),
            );
          }

          // // error
          // if (snapshot.hasError) {
          //   return const Center(child: Text('Error loading tickets'));
          // }

          // return Container();
        });
  }
}
