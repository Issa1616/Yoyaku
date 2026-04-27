import 'package:supabase_flutter/supabase_flutter.dart';

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
}
