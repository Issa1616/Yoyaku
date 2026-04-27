import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/owner_model.dart';

class OwnerService {
  final supabase = Supabase.instance.client;

  Future<List<OwnerModel>> getOwners() async {
    final role = await supabase
        .from('roles')
        .select('id')
        .eq('name', 'owner')
        .single();

    final data = await supabase.from('users').select().eq('rol_id', role['id']);

    return (data as List).map((e) => OwnerModel.fromMap(e)).toList();
  }

  Future removeOwner(String userId) async {
    final currentUser = supabase.auth.currentUser;

    if (currentUser!.id == userId) {
      throw Exception("No puedes quitarte permisos");
    }

    final userRole = await supabase
        .from('roles')
        .select('id')
        .eq('name', 'user')
        .single();

    await supabase
        .from('users')
        .update({'rol_id': userRole['id']})
        .eq('id', userId);

    await supabase.from('business').delete().eq('owner_id', userId);
  }
}
