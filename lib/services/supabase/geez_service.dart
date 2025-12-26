import 'package:kemey_app/services/supabase/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GeezService {
  static Future<PostgrestList> getBaseLetters() async {
    return await supabase
        .from('tigrinya_fidel')
        .select()
        .eq('order_index', 1);
  }

  static Future<PostgrestList> getBaseLetterVariants(String baseLetter) async {
    return await supabase
        .from('tigrinya_fidel')
        .select()
        .eq('base_letter', baseLetter)
        .order('order_index', ascending: true);
  }
}

