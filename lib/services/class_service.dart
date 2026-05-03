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

  Future<List<Map<String, dynamic>>> getInstructorUpcomingSessions() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception("No hay usuario logueado");
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final nextWeek = today.add(const Duration(days: 7));

    final startDate =
        "${today.year.toString().padLeft(4, '0')}-"
        "${today.month.toString().padLeft(2, '0')}-"
        "${today.day.toString().padLeft(2, '0')}";

    final endDate =
        "${nextWeek.year.toString().padLeft(4, '0')}-"
        "${nextWeek.month.toString().padLeft(2, '0')}-"
        "${nextWeek.day.toString().padLeft(2, '0')}";

    final res = await supabase
        .from('class_sessions')
        .select('''
        *,
        classes(
          class_types(name),
          business(name),
          image
        )
      ''')
        .eq('instructor_id', user.id)
        .gte('session_date', startDate)
        .lte('session_date', endDate)
        .order('session_date', ascending: true)
        .order('start_time', ascending: true);

    return List<Map<String, dynamic>>.from(res);
  }

  Future<void> cancelSession(int id) async {
    await supabase.from('class_sessions').delete().eq('id', id);
  }
}
