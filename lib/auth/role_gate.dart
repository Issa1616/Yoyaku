import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../home/admin_home.dart';
import '../../home/owner_home.dart';
import '../../home/instructor_home.dart';
import '../../home/user_home.dart';

class RoleGate extends StatelessWidget {
  final String userId;

  const RoleGate({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    return FutureBuilder(
      future: supabase.from('users').select('rol_id').eq('id', userId).single(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: Text("Error cargando rol")),
          );
        }

        final role = snapshot.data!['rol_id'];

        switch (role) {
          case 1:
            return const AdminHome();
          case 2:
            return const OwnerHome();
          case 3:
            return const InstructorHome();
          default:
            return const UserHome();
        }
      },
    );
  }
}
