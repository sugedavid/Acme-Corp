// Import the test package and Counter class
import 'package:acme_corp/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:test/test.dart';

void main() {
  group(
    'Utils',
    (() {
      test('navItems should return correctly', () {
        final drawerItems = navItems;

        expect(drawerItems.length, 3);
      });

      test('customerItems should return correctly', () {
        final drawerItems = customerItems;

        expect(drawerItems.length, 2);
      });

      test('transitions should return correctly', () {
        final items = transitions;

        expect(items.length, 6);
      });

      test('statusColor should return correctly', () {
        expect(statusColor('OPEN'), Colors.green[100]);
        expect(statusColor('IN-PROGRESS'), Colors.orange[100]);
        expect(statusColor('BLOCKED'), Colors.red[100]);
        expect(statusColor('RESOLVED'), Colors.purple[100]);
        expect(statusColor('RE-OPENED'), Colors.blue[100]);
        expect(statusColor('CLOSED'), Colors.brown[100]);
        expect(statusColor(''), Colors.grey);
      });
    }),
  );
}
