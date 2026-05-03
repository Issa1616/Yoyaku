import 'package:supabase_flutter/supabase_flutter.dart';
import 'business_service.dart';

class ClassService {
  final supabase = Supabase.instance.client;
  final businessService = BusinessService();

  Future<List<Map<String, dynamic>>> getClassTypes() async {
    final businessId = await businessService.getMyBusinessId();

    if (businessId == null) {
      throw Exception("No tienes negocio");
    }

    final res = await supabase
        .from('class_types')
        .select()
        .eq('business_id', businessId)
        .order('name');

    return List<Map<String, dynamic>>.from(res);
  }

  Future<List<Map<String, dynamic>>> getInstructors() async {
    final businessId = await businessService.getMyBusinessId();

    if (businessId == null) {
      throw Exception("No tienes negocio");
    }

    final res = await supabase
        .from('business_instructors')
        .select('users(*)')
        .eq('business_id', businessId);

    return (res as List)
        .map((e) => e['users'] as Map<String, dynamic>)
        .toList();
  }

  Future<List<Map<String, dynamic>>> getClasses() async {
    final businessId = await businessService.getMyBusinessId();

    if (businessId == null) return [];

    final res = await supabase
        .from('classes')
        .select('''
          *,
          class_types(name),
          users(name)
        ''')
        .eq('business_id', businessId)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(res);
  }

  Future<void> createClass({
    required int classTypeId,
    required String instructorId,
  }) async {
    final businessId = await businessService.getMyBusinessId();

    if (businessId == null) {
      throw Exception("No tienes negocio");
    }

    await supabase.from('classes').insert({
      'classtype_id': classTypeId,
      'instructor_id': instructorId,
      'business_id': businessId,
      'title': '',
      'description': '',
      'date': DateTime.now().toIso8601String(),
      'time': '00:00:00',
      'end_time': '00:00:00',
      'cupo_max': 0,
    });
  }

  Future<void> deleteClass(int id) async {
    await supabase.from('classes').delete().eq('id', id);
  }
}
