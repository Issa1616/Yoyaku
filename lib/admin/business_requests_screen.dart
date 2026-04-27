import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BusinessRequestsScreen extends StatefulWidget {
  const BusinessRequestsScreen({super.key});

  @override
  State<BusinessRequestsScreen> createState() => _BusinessRequestsScreenState();
}

class _BusinessRequestsScreenState extends State<BusinessRequestsScreen> {
  final supabase = Supabase.instance.client;

  List requests = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadRequests();
  }

  Future loadRequests() async {
    final data = await supabase
        .from('owner_requests')
        .select('*, users(name,email)')
        .eq('status', 'pending');

    setState(() {
      requests = data;
      loading = false;
    });
  }

  Future approveRequest(Map request) async {
    final ownerRole = await supabase
        .from('roles')
        .select('id')
        .eq('name', 'owner')
        .single();

    /// 1️⃣ Crear negocio
    final business = await supabase
        .from('business')
        .insert({
          'name': request['business_name'],
          'ubicacion': request['ubicacion'],
          'owner_id': request['user_id'],
        })
        .select()
        .single();

    /// 2️⃣ Convertir usuario en OWNER
    await supabase
        .from('users')
        .update({'rol_id': ownerRole['id']})
        .eq('id', request['user_id']);

    /// 3️⃣ Marcar solicitud aprobada
    await supabase
        .from('business_requests')
        .update({'status': 'approved'})
        .eq('id', request['id']);

    loadRequests();
  }

  Future rejectRequest(int id) async {
    await supabase
        .from('business_requests')
        .update({'status': 'rejected'})
        .eq('id', id);

    loadRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Solicitudes de Owner")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : requests.isEmpty
          ? const Center(child: Text("No hay solicitudes"))
          : ListView.builder(
              itemCount: requests.length,
              itemBuilder: (_, i) {
                final r = requests[i];

                return Card(
                  margin: const EdgeInsets.all(12),
                  child: ListTile(
                    title: Text(r['business_name']),
                    subtitle: Text(
                      "${r['users']['name']} • ${r['users']['email']}",
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          onPressed: () => approveRequest(r),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () => rejectRequest(r['id']),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
