import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/instructor_model.dart';

class InstructorService {
  final supabase = Supabase.instance.client;

  static const instructorRoleId = 3;

  Future<List<InstructorModel>> getInstructors(int businessId) async {
    print("🔥 BUSCANDO BUSINESS ID: $businessId");

    final relations = await supabase
        .from('business_instructors')
        .select('instructor_id')
        .eq('business_id', businessId);

    print("🔥 RELATIONS:");
    print(relations);

    final ids = (relations as List).map((e) => e['instructor_id']).toList();

    if (ids.isEmpty) {
      print("❌ NO HAY IDS");
      return [];
    }

    final users = await supabase
        .from('users')
        .select('id,name,email')
        .inFilter('id', ids);

    print("🔥 USERS:");
    print(users);

    return (users as List).map((e) => InstructorModel.fromMap(e)).toList();
  }

  Future<void> inviteInstructor(String email, int businessId) async {
    final user = await supabase
        .from('users')
        .select('id')
        .eq('email', email)
        .maybeSingle();

    if (user == null) {
      throw Exception("Usuario no existe");
    }

    await supabase.from('business_instructors').insert({
      'business_id': businessId,
      'instructor_id': user['id'],
      'status': 'pending',
    });
  }

  Future<void> removeInstructor(String userId, int businessId) async {
    await supabase
        .from('business_instructors')
        .delete()
        .eq('business_id', businessId)
        .eq('instructor_id', userId);

    await supabase.from('users').update({'role_id': 2}).eq('id', userId);
  }
}
