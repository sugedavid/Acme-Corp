import 'package:acme_corp/core/utils.dart';
import 'package:acme_corp/presentation/shared/color_schemes.g.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class DashboardFragment extends StatefulWidget {
  const DashboardFragment({Key? key}) : super(key: key);

  @override
  State<DashboardFragment> createState() => _DashboardFragmentState();
}

class _DashboardFragmentState extends State<DashboardFragment> {
  String agent = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  Widget build(BuildContext context) {
    var tickets = <dynamic>[];
    var users = <dynamic>[];

    var open = <dynamic>[];
    var inProgress = <dynamic>[];
    var blocked = <dynamic>[];
    var resolved = <dynamic>[];
    var reopened = <dynamic>[];
    var closed = <dynamic>[];

    return Scaffold(
      body: StreamBuilder<Object>(
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
              open.clear();
              inProgress.clear();
              blocked.clear();
              resolved.clear();
              reopened.clear();
              closed.clear();

              ticketsSnapshot.forEach((key, value) {
                if (value['agent'] == agent) {
                  tickets.add(value);

                  switch (value['status']) {
                    case 'OPEN':
                      open.add(value);
                      break;
                    case 'IN-PROGRESS':
                      inProgress.add(value);
                      break;
                    case 'BLOCKED':
                      blocked.add(value);
                      break;
                    case 'RESOLVED':
                      resolved.add(value);
                      break;
                    case 'RE-OPENED':
                      reopened.add(value);
                      break;
                    case 'CLOSED':
                      closed.add(value);
                      break;
                    default:
                  }
                }
              });
            }
            return ListView(shrinkWrap: true, children: [
              if (tickets.isNotEmpty) ...{
                // pie chat
                SizedBox(
                  height: 300,
                  child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: PieChart(PieChartData(
                          centerSpaceRadius: 5,
                          borderData: FlBorderData(show: false),
                          sectionsSpace: 2,
                          sections: [
                            PieChartSectionData(
                                value: open.length.toDouble(),
                                color: statusColor('OPEN'),
                                radius: 100),
                            PieChartSectionData(
                                value: inProgress.length.toDouble(),
                                color: statusColor('IN-PROGRESS'),
                                radius: 100),
                            PieChartSectionData(
                                value: blocked.length.toDouble(),
                                color: statusColor('BLOCKED'),
                                radius: 100),
                            PieChartSectionData(
                                value: resolved.length.toDouble(),
                                color: statusColor('RESOLVED'),
                                radius: 100),
                            PieChartSectionData(
                                value: reopened.length.toDouble(),
                                color: statusColor('RE-OPENED'),
                                radius: 100),
                            PieChartSectionData(
                                value: closed.length.toDouble(),
                                color: statusColor('CLOSED'),
                                radius: 100),
                          ]))),
                )
              } else ...{
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('No data'),
                  ),
                ),
              },

              // tickets
              Card(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      alignment: WrapAlignment.center,
                      children: [
                        // total tickets
                        SizedBox(
                          width: 100,
                          child: ListTile(
                            title: const Text(
                              'TOTAL',
                              style: TextStyle(fontSize: 12),
                            ),
                            subtitle: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: Text(
                                    tickets.length.toString(),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                                Container(
                                  color: statusColor(''),
                                  height: 12,
                                  width: 12,
                                )
                              ],
                            ),
                          ),
                        ),

                        // open tickets
                        SizedBox(
                          width: 100,
                          child: ListTile(
                            title: const Text(
                              'OPEN',
                              style: TextStyle(fontSize: 12),
                            ),
                            subtitle: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: Text(
                                    open.length.toString(),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                                Container(
                                  color: statusColor('OPEN'),
                                  height: 12,
                                  width: 12,
                                )
                              ],
                            ),
                          ),
                        ),

                        // in progress tickets
                        SizedBox(
                          width: 100,
                          child: ListTile(
                            title: const Text(
                              'IN-PROGRESS',
                              style: TextStyle(fontSize: 12),
                            ),
                            subtitle: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: Text(
                                    inProgress.length.toString(),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                                Container(
                                  color: statusColor('IN-PROGRESS'),
                                  height: 12,
                                  width: 12,
                                )
                              ],
                            ),
                          ),
                        ),

                        // blocked tickets
                        SizedBox(
                          width: 100,
                          child: ListTile(
                            title: const Text(
                              'BLOCKED',
                              style: TextStyle(fontSize: 12),
                            ),
                            subtitle: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: Text(
                                    blocked.length.toString(),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                                Container(
                                  color: statusColor('BLOCKED'),
                                  height: 12,
                                  width: 12,
                                )
                              ],
                            ),
                          ),
                        ),

                        // resolved tickets
                        SizedBox(
                          width: 100,
                          child: ListTile(
                            title: const Text(
                              'RESOLVED',
                              style: TextStyle(fontSize: 12),
                            ),
                            subtitle: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: Text(
                                    resolved.length.toString(),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                                Container(
                                  color: statusColor('RESOLVED'),
                                  height: 12,
                                  width: 12,
                                )
                              ],
                            ),
                          ),
                        ),

                        // reopend tickets
                        SizedBox(
                          width: 100,
                          child: ListTile(
                            title: const Text(
                              'RE-OPENED',
                              style: TextStyle(fontSize: 12),
                            ),
                            subtitle: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: Text(
                                    reopened.length.toString(),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                                Container(
                                  color: statusColor('RE-OPENED'),
                                  height: 12,
                                  width: 12,
                                )
                              ],
                            ),
                          ),
                        ),

                        // closed tickets
                        SizedBox(
                          width: 100,
                          child: ListTile(
                            title: const Text(
                              'CLOSED',
                              style: TextStyle(fontSize: 12),
                            ),
                            subtitle: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: Text(
                                    closed.length.toString(),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                                Container(
                                  color: statusColor('CLOSED'),
                                  height: 12,
                                  width: 12,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),

              // agents
              StreamBuilder<Object>(
                  stream: FirebaseDatabase.instance.ref('users').onValue,
                  builder: (context, snapshot2) {
                    // data
                    if ((snapshot2.hasData &&
                        snapshot2.data != null &&
                        (snapshot2.data! as DatabaseEvent).snapshot.value !=
                            null)) {
                      var usersSnapshot = Map<dynamic, dynamic>.from(
                          (snapshot2.data as DatabaseEvent).snapshot.value
                              as Map<dynamic, dynamic>);

                      users.clear();

                      usersSnapshot.forEach((key, value) {
                        if (value['userType'] == 'Agent') {
                          users.add(value);
                        }
                      });

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        child: DropdownButton(
                          isExpanded: false,
                          value: agent,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: users.map((dynamic items) {
                            return DropdownMenuItem(
                              value: items['userId'],
                              child: Text(
                                items['name'],
                                style: const TextStyle(fontSize: 12),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              agent = value.toString();
                            });
                          },
                        ),
                      );
                    }

                    return Container();
                  }),
            ]);
          }),
    );
  }
}
