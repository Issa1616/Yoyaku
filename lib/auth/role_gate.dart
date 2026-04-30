import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  int? roleId;

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
          roleId = null;
        });
        return;
      }

      final response = await supabase
          .from('users')
          .select('role_id')
          .eq('id', user.id)
          .maybeSingle();

      setState(() {
        roleId = response?['role_id'];
        loading = false;
      });
    } catch (e) {
      debugPrint("RoleGate error: $e");
      setState(() {
        roleId = null;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (roleId == null) {
      return const Scaffold(body: Center(child: Text("Error cargando rol")));
    }

    switch (roleId) {
      case 1:
        return const AdminShell();

      case 2:
        return const OwnerShell();

      case 3:
        return const InstructorShell();

      default:
        return const UserShell();
    }
  }
}
