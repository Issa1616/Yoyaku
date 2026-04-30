import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  final supabase = Supabase.instance.client;

  Future<Map<String, dynamic>> getMyUser() async {
    final uid = supabase.auth.currentUser!.id;

    final data = await supabase.from('users').select().eq('id', uid).single();

    return data;
  }

  Future<void> updateUser(String name) async {
    final uid = supabase.auth.currentUser!.id;

    await supabase.from('users').update({'name': name}).eq('id', uid);
  }

  Future<void> updateImage(String imageUrl) async {
    final uid = supabase.auth.currentUser!.id;

    await supabase.from('users').update({'image': imageUrl}).eq('id', uid);
  }
}
