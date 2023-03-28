import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final navProvider = StateProvider<int>((ref) {
  return 0;
});

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
  },
  {
    'title': const Text(
      'Tickets',
      style: TextStyle(fontSize: 14),
    ),
    'icon': const Icon(
      Icons.receipt_long_outlined,
      size: 18,
    ),
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
  }
];
