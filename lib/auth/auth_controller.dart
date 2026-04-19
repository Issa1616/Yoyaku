import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController {
  final supabase = Supabase.instance.client;

  Future<String?> login(String email, String password) async {
    try {
      await supabase.auth.signInWithPassword(email: email, password: password);

      return null;
    } catch (e) {
      return "Error al iniciar sesión";
    }
  }

  Future<String?> register(String name, String email, String password) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      final userId = response.user?.id;

      if (userId != null) {
        await supabase.from('users').update({'name': name}).eq('id', userId);
      }
      return null;
    } catch (e) {
      return "Error al registrarse";
    }
  }

  Future<void> logout() async {
    await supabase.auth.signOut();
  }

  Session? get session => supabase.auth.currentSession;
}
