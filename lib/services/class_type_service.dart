import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/class_type_model.dart';
import 'business_service.dart';

class ClassTypeService {
  final supabase = Supabase.instance.client;
  final businessService = BusinessService();

  Future<List<ClassTypeModel>> getClassTypes() async {
    final businessId = await businessService.getMyBusinessId();
    final response = await supabase
        .from('class_type')
        .select('''
          id,
          name,
          description
        ''')
        .eq('business_id', businessId!)
        .order('id');

    return (response as List).map((e) => ClassTypeModel.fromMap(e)).toList();
  }

  Future<void> createClassType(String name, String description) async {
    final businessId = await businessService.getMyBusinessId();
    await supabase.from('class_type').insert({
      'name': name,
      'description': description,
      'business_id': businessId,
    });
  }

  Future<void> updateClassType(int id, String name, String description) async {
    await supabase
        .from('class_type')
        .update({'name': name, 'description': description})
        .eq('id', id);
  }

  Future<void> deleteClassType(int id) async {
    await supabase.from('class_type').delete().eq('id', id);
  }
}
