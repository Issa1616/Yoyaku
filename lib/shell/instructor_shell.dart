import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../home/instructor_home.dart';
import '../instructor/class_session_screen.dart';
import '../settings/instructor_settings.dart';

class InstructorShell extends StatefulWidget {
  const InstructorShell({super.key});

  @override
  State<InstructorShell> createState() => _InstructorShellState();
}

class _InstructorShellState extends State<InstructorShell> {
  int currentIndex = 0;

  late final String instructorId;

  @override
  void initState() {
    super.initState();

    instructorId = Supabase.instance.client.auth.currentUser!.id;
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const InstructorHome(),
      ClassSessionScreen(instructorId: instructorId),
      const InstructorSettings(),
    ];

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
