import 'package:flutter/material.dart';
import '../../widgets/header_yoyaku.dart';
import '../../services/admin_service.dart';
import '../../models/admin_user_model.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final service = AdminService();

  List<AdminUserModel> owners = [];
  List businesses = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => loading = true);

    final o = await service.getOwnersWithBusiness();
    final b = await service.getBusinesses();

    setState(() {
      owners = o;
      businesses = b;
      loading = false;
    });
  }

  Future<void> downgrade(String id) async {
    await service.downgradeToUser(id);
    await loadData();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Owner degradado a user")));
  }

  Future<void> deleteBusiness(int id) async {
    await service.deleteBusiness(id);
    await loadData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: ListView(
                children: [
                  const YoyakuHeader(),

                  const SizedBox(height: 20),

                  const Text(
                    "Owners",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  ...owners.map((o) {
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(o.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(o.email),
                            if (o.businessName != null)
                              Text("🏪 ${o.businessName}"),
                          ],
                        ),
                        trailing: TextButton(
                          onPressed: () => downgrade(o.id),
                          child: const Text("Degradar"),
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 30),

                  const Text(
                    "Negocios",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  ...businesses.map((b) {
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.store),
                        title: Text(b['name']),
                        subtitle: Text(b['ubicacion'] ?? ''),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteBusiness(b['id']),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
    );
  }
}
