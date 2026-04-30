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

  Future<void> createClass({
    required int classTypeId,
    required String instructorId,
    required String title,
    required String description,
    required DateTime date,
    required String time,
    required String endTime,
    required int cupo,
    String? image,
  }) async {
    final businessId = await businessService.getMyBusinessId();

    if (businessId == null) {
      throw Exception("No tienes negocio");
    }

    await supabase.from('classes').insert({
      'classtype_id': classTypeId,
      'instructor_id': instructorId,
      'business_id': businessId,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'time': time,
      'end_time': endTime,
      'cupo_max': cupo,
      'image': image,
    });
  }
}
