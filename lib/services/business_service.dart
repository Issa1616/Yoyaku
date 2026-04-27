import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/business_model.dart';

class BusinessService {
  final supabase = Supabase.instance.client;

  Future<int?> getMyBusinessId() async {
    final user = supabase.auth.currentUser;

    final response = await supabase
        .from('business')
        .select('id')
        .eq('owner_id', user!.id)
        .single();

    return response['id'];
  }

  Future<List<BusinessModel>> getAllBusinesses() async {
    final response = await supabase.from('business').select().order('id');

    return (response as List).map((e) => BusinessModel.fromJson(e)).toList();
  }

  Future<void> deleteBusiness(int id) async {
    await supabase.from('business').delete().eq('id', id);
  }
}
