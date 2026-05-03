import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/class_session_model.dart';

class ClassSessionService {
  final SupabaseClient client;

  ClassSessionService(this.client);

  Future<void> createSession(ClassSessionModel session) async {
    await client.from('class_sessions').insert(session.toMap());
  }

  Future<List<ClassSessionModel>> getSessionsByClass(int classId) async {
    final res = await client
        .from('class_sessions')
        .select()
        .eq('class_id', classId);

    return (res as List).map((e) => ClassSessionModel.fromMap(e)).toList();
  }

  Future<void> deleteSession(int id) async {
    await client.from('class_sessions').delete().eq('id', id);
  }
}
