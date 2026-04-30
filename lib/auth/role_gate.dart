import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yoyaku/shell/admin_shell.dart';
import 'package:yoyaku/shell/instructor_shell.dart';
import 'package:yoyaku/shell/user_shell.dart';

import '../../shell/admin_shell.dart';
import '../../shell/owner_shell.dart';
import '../../shell/instructor_shell.dart';
import '../../shell/user_shell.dart';

class RoleGate extends StatefulWidget {
  const RoleGate({super.key});

  @override
  State<RoleGate> createState() => _RoleGateState();
}

class _RoleGateState extends State<RoleGate> {
  final supabase = Supabase.instance.client;

  bool loading = true;
  String? role;

  @override
  void initState() {
    super.initState();
    loadRole();
  }

  Future<void> loadRole() async {
    try {
      final user = supabase.auth.currentUser;

      if (user == null) {
        setState(() {
          loading = false;
          role = null;
        });
        return;
      }

      final response = await supabase
          .from('users')
          .select('roles(name)')
          .eq('id', user.id)
          .maybeSingle();

      final roleName = response?['roles']?['name'];

      setState(() {
        role = roleName;
        loading = false;
      });
    } catch (e) {
      debugPrint("Error cargando rol: $e");
      setState(() {
        role = null;
        loading = false;
      });
    }
  }

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
