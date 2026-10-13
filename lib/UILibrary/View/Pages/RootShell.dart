import 'package:flutter/material.dart';

import 'HomeScreen.dart';
import 'MyBookingsScreen.dart';
import 'ProviderJobsScreen.dart';

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KeyedSubtree(
        key: ValueKey<int>(_index),
        child: _screenFor(_index),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) => setState(() => _index = index),
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long_rounded),
            label: 'My Bookings',
          ),
          NavigationDestination(
            icon: Icon(Icons.work_outline_rounded),
            selectedIcon: Icon(Icons.work_rounded),
            label: 'Provider',
          ),
        ],
      ),
    );
  }

  Widget _screenFor(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return const MyBookingsScreen();
      case 2:
      default:
        return const ProviderJobsScreen();
    }
  }
}
