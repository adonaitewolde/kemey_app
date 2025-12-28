import 'package:supabase_flutter/supabase_flutter.dart';
import './supabase_service.dart';

class FlashcardService {
  static Future<PostgrestList> getFlashCardSets() async {
    return await supabase
        .from('flashcard_sets')
        .select()
        .order('order_index', ascending: true);
  }

  static Future<PostgrestList> getFlashCards(String flashCardSet) async {
    return await supabase
        .from('flashcards')
        .select()
        .eq('set_id', flashCardSet)
        .order('order_index', ascending: true);
  }
}
