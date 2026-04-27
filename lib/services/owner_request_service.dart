import 'package:supabase_flutter/supabase_flutter.dart';

class OwnerRequestService {
  final supabase = Supabase.instance.client;

  Future<List> getRequests() async {
    return await supabase
        .from('owner_requests')
        .select()
        .eq('status', 'pending');
  }

  Future createRequest(String name, String ubicacion) async {
    final user = supabase.auth.currentUser;

    await supabase.from('owner_requests').insert({
      'user_id': user!.id,
      'business_name': name,
      'ubicacion': ubicacion,
    });
  }

  Future approveRequest(Map request) async {
    final ownerRole = await supabase
        .from('roles')
        .select('id')
        .eq('name', 'owner')
        .single();

    /// crear negocio
    await supabase.from('business').insert({
      'name': request['business_name'],
      'ubicacion': request['ubicacion'],
      'owner_id': request['user_id'],
    });

    /// cambiar rol
    await supabase
        .from('users')
        .update({'rol_id': ownerRole['id']})
        .eq('id', request['user_id']);

    /// actualizar solicitud
    await supabase
        .from('owner_requests')
        .update({'status': 'approved'})
        .eq('id', request['id']);
  }

  Future rejectRequest(int id) async {
    await supabase
        .from('owner_requests')
        .update({'status': 'rejected'})
        .eq('id', id);
  }
}
