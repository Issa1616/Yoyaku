import 'package:flutter/material.dart';
import '../../widgets/header_yoyaku.dart';
import '../../services/owner_service.dart';
import '../../models/owner_model.dart';
import 'business_requests_screen.dart';

class OwnersScreen extends StatefulWidget {
  const OwnersScreen({super.key});

  @override
  State<OwnersScreen> createState() => _OwnersScreenState();
}

class _OwnersScreenState extends State<OwnersScreen> {
  final service = OwnerService();

  List<OwnerModel> owners = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadOwners();
  }

  Future loadOwners() async {
    owners = await service.getOwners();
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const YoyakuHeader(),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Owners",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                ),

                ElevatedButton.icon(
                  icon: const Icon(Icons.pending_actions),
                  label: const Text("Solicitudes"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const BusinessRequestsScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            ...owners.map(
              (o) => Card(
                child: ListTile(
                  title: Text(o.name),
                  subtitle: Text(o.email),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () async {
                      await service.removeOwner(o.id);
                      loadOwners();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
