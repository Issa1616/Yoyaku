import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class BusinessService {
  final supabase = Supabase.instance.client;

  /// ======================================
  /// OBTENER NEGOCIO DEL OWNER
  /// ======================================
  Future<Map<String, dynamic>> getMyBusiness() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception("Usuario no autenticado");
    }

    final data = await supabase
        .from('business')
        .select()
        .eq('owner_id', user.id)
        .single();

    return data;
  }

  /// ======================================
  /// ACTUALIZAR NEGOCIO
  /// ======================================
  Future<void> updateBusiness(
    String name,
    String ubicacion,
    String? photo,
  ) async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception("Usuario no autenticado");
    }

    await supabase
        .from('business')
        .update({'name': name, 'ubicacion': ubicacion, 'photo': photo})
        .eq('owner_id', user.id);
  }

  /// ======================================
  /// SUBIR FOTO A STORAGE
  /// ======================================
  Future<String> uploadBusinessPhoto(File file) async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception("Usuario no autenticado");
    }

    final fileName =
        "business_${user.id}_${DateTime.now().millisecondsSinceEpoch}.jpg";

    await supabase.storage.from('business').upload(fileName, file);

    /// obtener url pública
    final publicUrl = supabase.storage.from('business').getPublicUrl(fileName);

    return publicUrl;
  }
}
