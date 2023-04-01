import 'package:acme_corp/core/services.dart';
import 'package:acme_corp/core/utils.dart';
import 'package:acme_corp/presentation/Home/components/CreateCustomerForm.dart';
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

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final messageController = TextEditingController();

    String userName = '';

    getUserInfo(userId, 'name').then((String result) {
      userName = result;
    });

    var converstions = <dynamic>[];

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
                color: lightColorScheme.primary,
                size: 18,
              ));
            }

            if (snapshot.hasData &&
                snapshot.data != null &&
                (snapshot.data! as DatabaseEvent).snapshot.value != null) {
              ticketInfo = Map<dynamic, dynamic>.from(
                  (snapshot.data! as DatabaseEvent).snapshot.value
                      as Map<dynamic, dynamic>);

              converstions.clear();

              ticketInfo['conversations']?.forEach((key, value) {
                converstions.add(value);
              });
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              // shrinkWrap: true,
              children: [
                // ticket info

                Card(
                  margin: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                  color: Colors.white,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    title: Text(ticketInfo['title'] ?? ''),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ticketInfo['description'] ?? '',
                          style: const TextStyle(fontSize: 12),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 10),
                        Chip(
                            backgroundColor:
                                statusColor(ticketInfo['status']) ??
                                    Colors.purple[100],
                            label: Text(
                              ticketInfo['status'] ?? '',
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
                                fontSize: 12,
                              )),
                          FutureBuilder(
                              future:
                                  getUserInfo(ticketInfo['customer'], 'name'),
                              builder: (context, snapshot) {
                                return Text(
                                  snapshot.data.toString(),
                                  style: const TextStyle(fontSize: 12),
                                );
                              }),
                          FutureBuilder(
                              future:
                                  getUserInfo(ticketInfo['customer'], 'email'),
                              builder: (context, snapshot) {
                                return Text(
                                  snapshot.data.toString(),
                                  style: const TextStyle(fontSize: 12),
                                );
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
                                  fontSize: 12)),
                          FutureBuilder(
                              future: getUserInfo(ticketInfo['agent'], 'name'),
                              builder: (context, snapshot) {
                                return Text(
                                  snapshot.data.toString(),
                                  style: const TextStyle(fontSize: 12),
                                );
                              }),
                          FutureBuilder(
                              future: getUserInfo(ticketInfo['agent'], 'email'),
                              builder: (context, snapshot) {
                                return Text(
                                  snapshot.data.toString(),
                                  style: const TextStyle(fontSize: 12),
                                );
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // actions

                Builder(builder: (context) {
                  return FutureBuilder(
                      future: getUserInfo(userId, 'userType'),
                      builder: (context, snapshot) {
                        return Wrap(
                          alignment: WrapAlignment.end,
                          children: [
                            if (snapshot.data.toString() == 'Agent') ...{
                              // view uploaded file
                              if (ticketInfo['fileUrl'] != null &&
                                  ticketInfo['fileUrl'] != '')
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: TextButton(
                                        onPressed: () => openFileUrl(
                                            context, ticketInfo['fileUrl']),
                                        child: const Text(
                                          'View file',
                                          style: TextStyle(fontSize: 12),
                                        )),
                                  ),
                                ),

                              //create customer

                              Flexible(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: TextButton(
                                      onPressed: () =>
                                          showCreateCustomer(context),
                                      child: const Text(
                                        'Create customer',
                                        style: TextStyle(fontSize: 12),
                                      )),
                                ),
                              ),

                              //assign customer

                              Flexible(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: TextButton(
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
                                      child: const Text(
                                        'Assign customer',
                                        style: TextStyle(fontSize: 12),
                                      )),
                                ),
                              ),

                              //assign agent
                              Flexible(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: TextButton(
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
                                      child: const Text(
                                        'Assign agent',
                                        style: TextStyle(fontSize: 12),
                                      )),
                                ),
                              ),
                            },

                            // transistion
                            Align(
                              alignment: Alignment.centerRight,
                              child: Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
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
                            ),
                          ],
                        );
                      });
                }),

                const SizedBox(height: 20),

                // conversations

                // message list
                converstions.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: converstions.length,
                          itemBuilder: (BuildContext context, int index) {
                            String messageTime =
                                converstions[index]?['time'] != null
                                    ? DateFormat.MMMEd().add_jm().format(
                                        DateTime.parse(
                                            converstions[index]?['time']))
                                    : '';

                            return ListTile(
                              title: Text(
                                converstions[index]?['senderName'] ?? '',
                                style: const TextStyle(fontSize: 12),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    converstions[index]?['message'] ?? '',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(messageTime,
                                      style: const TextStyle(fontSize: 8))
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    : const Expanded(
                        child: Center(child: Text('No conversations'))),

                // send message
                Form(
                  key: formKey,
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          // The chat input field
                          Flexible(
                            child: TextFormField(
                              controller: messageController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration.collapsed(
                                hintText: 'Send a message',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Write a message';
                                }
                                return null;
                              },
                            ),
                          ),

                          // send
                          IconButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  sendMessage(
                                          context,
                                          ticketInfo['id'],
                                          messageController.text,
                                          userId,
                                          userName)
                                      .then((value) =>
                                          messageController.text = '');
                                }
                              },
                              icon: Icon(
                                Icons.send_rounded,
                                color: lightColorScheme.primary,
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
