import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController {
  final supabase = Supabase.instance.client;

  Future<String?> login(String email, String password) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.session == null) {
        return "No se pudo iniciar sesión";
      }

      return null;
    } catch (e) {
      return "Error al iniciar sesión";
    }
  }

  Future<String?> register(String name, String email, String password) async {
    try {
      await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );

      return null;
    } catch (e) {
      print(e);
      return "Error al registrarse";
    }
  }

  Future<void> logout() async {
    await supabase.auth.signOut();
  }

  Session? get session => supabase.auth.currentSession;
}
