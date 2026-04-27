import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/class_model.dart';

class ClassService {
  final supabase = Supabase.instance.client;

  Future<List<ClassModel>> getClasses() async {
    final response = await supabase
        .from('classes')
        .select('''
          id,
          date,
          time,
          class_type(name),
          users(name)
        ''')
        .order('date');

    return (response as List).map((e) => ClassModel.fromMap(e)).toList();
  }
}
