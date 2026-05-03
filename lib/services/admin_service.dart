import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/admin_user_model.dart';

class AdminService {
  final supabase = Supabase.instance.client;

  Future<List<AdminUserModel>> getOwnersWithBusiness() async {
    final ownerRole = await supabase
        .from('roles')
        .select('id')
        .eq('name', 'owner')
        .single();

    final res = await supabase
        .from('users')
        .select('''
          id,
          name,
          email,
          role_id,
          roles ( name ),
          business ( name )
        ''')
        .eq('role_id', ownerRole['id']);

    return (res as List).map((e) => AdminUserModel.fromJson(e)).toList();
  }

  Future<void> downgradeToUser(String userId) async {
    final userRole = await supabase
        .from('roles')
        .select('id')
        .eq('name', 'user')
        .single();

    await supabase
        .from('users')
        .update({'role_id': userRole['id']})
        .eq('id', userId);
  }

  Future<List> getBusinesses() async {
    return await supabase.from('business').select('*');
  }

  Future<void> deleteBusiness(int id) async {
    await supabase.from('business').delete().eq('id', id);
  }
}
