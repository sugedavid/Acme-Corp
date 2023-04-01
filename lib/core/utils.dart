import 'package:acme_corp/domain/strings.dart';
import 'package:acme_corp/presentation/Home/components/DashboardFragment.dart';
import 'package:acme_corp/presentation/Home/components/TicketsFragment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

// navigation state
final navProvider = StateProvider<int>((ref) {
  return 0;
});

// navigation state
final navItemsProvider = StateProvider<dynamic>((ref) {
  return customerItems;
});

// ticket state
final ticketProvider = StateProvider<Map<String, String>>((ref) {
  return {};
});

// navigation drawer items
final List<Map<dynamic, dynamic>> navItems = [
  {
    'title': const Text(
      'Dashboard',
      style: TextStyle(fontSize: 14),
    ),
    'icon': const Icon(
      Icons.dashboard_outlined,
      size: 18,
    ),
    'widget': const DashboardFragment(),
  },
  {
    'title': const Text(
      'Tickets',
      style: TextStyle(fontSize: 14),
    ),
    'icon': const Icon(
      Icons.assignment_outlined,
      size: 18,
    ),
    'widget': const TicketsFragment(),
  },
  {
    'title': const Text(
      'Log out',
      style: TextStyle(fontSize: 14, color: Colors.red),
    ),
    'icon': Icon(
      Icons.logout_outlined,
      color: Colors.red.withOpacity(0.7),
      size: 18,
    ),
    'widget': const Center(child: Text('Welcome to $appName')),
  }
];

final List<Map<dynamic, dynamic>> customerItems = [
  {
    'title': const Text(
      'Tickets',
      style: TextStyle(fontSize: 14),
    ),
    'icon': const Icon(
      Icons.assignment_outlined,
      size: 18,
    ),
    'widget': const TicketsFragment(),
  },
  {
    'title': const Text(
      'Log out',
      style: TextStyle(fontSize: 14, color: Colors.red),
    ),
    'icon': Icon(
      Icons.logout_outlined,
      color: Colors.red.withOpacity(0.7),
      size: 18,
    ),
    'widget': const Center(child: Text('Welcome to $appName')),
  }
];

// List of transitions
List<String> transitions(status, userType) {
  if (status.isEmpty || userType.isEmpty) {
    return [
      'OPEN',
      'IN-PROGRESS',
      'BLOCKED',
      'RESOLVED',
      'RE-OPENED',
      'CLOSED',
    ];
  } else {
    switch (status) {
      case 'OPEN':
        return [
          'OPEN',
          'IN-PROGRESS',
          'BLOCKED',
          'CLOSED',
        ];
      case 'IN-PROGRESS':
        return [
          'IN-PROGRESS',
          'BLOCKED',
          'CLOSED',
        ];
      case 'RESOLVED':
        return [
          'RESOLVED',
          'RE-OPENED',
        ];
      case 'RE-OPENED':
        return [
          'IN-PROGRESS',
          'BLOCKED',
          'RESOLVED',
          'RE-OPENED',
          'CLOSED',
        ];
      case 'BLOCKED':
        return [
          'BLOCKED',
          'RE-OPENED',
        ];
      case 'CLOSED':
        return [
          'CLOSED',
          'RE-OPENED',
        ];
      default:
        return [
          'OPEN',
          'IN-PROGRESS',
          'BLOCKED',
          'RESOLVED',
          'RE-OPENED',
          'CLOSED',
        ];
    }
  }
}

Color? statusColor(status) {
  switch (status) {
    case 'OPEN':
      return Colors.green[100];
    case 'IN-PROGRESS':
      return Colors.orange[100];
    case 'BLOCKED':
      return Colors.red[100];
    case 'RESOLVED':
      return Colors.purple[100];
    case 'RE-OPENED':
      return Colors.blue[100];
    case 'CLOSED':
      return Colors.brown[100];
    default:
      return Colors.grey;
  }
}

// open file url
Future<void> openFileUrl(context, fileUrl) async {
  final Uri url = Uri.parse(fileUrl);
  if (!await launchUrl(url)) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Could not launch $url'),
    ));
  }
}
