import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yoyaku/shell/admin_shell.dart';
import 'package:yoyaku/shell/instructor_shell.dart';
import 'package:yoyaku/shell/user_shell.dart';

import '../../shell/admin_shell.dart';
import '../../shell/owner_shell.dart';
import '../../shell/instructor_shell.dart';
import '../../shell/user_shell.dart';

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
            return const AdminShell();
          case 2:
            return const OwnerShell();
          case 3:
            return const InstructorShell();
          default:
            return const UserShell();
        }
      },
    );
  }
}
