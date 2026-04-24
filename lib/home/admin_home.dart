import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '/layout/menu_drawer.dart';
import '/layout/drawer_items.dart';
import '/auth/login_screen.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  Future<void> logout(BuildContext context) async {
    await Supabase.instance.client.auth.signOut();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      DrawerItem(
        title: "Inicio",
        icon: Icons.home,
        onTap: () => Navigator.pop(context),
      ),
      DrawerItem(
        title: "Usuarios",
        icon: Icons.people,
        onTap: () => Navigator.pop(context),
      ),
      DrawerItem(
        title: "Negocios",
        icon: Icons.business,
        onTap: () => Navigator.pop(context),
      ),
      DrawerItem(
        title: "Cerrar sesión",
        icon: Icons.logout,
        onTap: () async {
          Navigator.pop(context);
          await logout(context);
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Admin - Yoyaku")),
      drawer: AppDrawer(roleName: "Admin", items: items),
      body: const Center(child: Text("Dashboard Admin")),
    );
  }
}
