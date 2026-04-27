import 'package:flutter/material.dart';
import '../home/instructor_home.dart';
import '../classes/instructor_classes.dart';
import '../settings/instructor_settings.dart';

class UserShell extends StatefulWidget {
  const UserShell({super.key});

  @override
  State<UserShell> createState() => _UserShellState();
}

class _UserShellState extends State<UserShell> {
  int currentIndex = 0;

  final pages = const [
    InstructorHome(),
    InstructorClasses(),
    InstructorSettings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: pages[currentIndex],
      ),

      bottomNavigationBar: NavigationBar(
        height: 70,
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() => currentIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_today),
            label: "Reservas",
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble),
            label: "Ajustes",
          ),
        ],
      ),
    );
  }
}
