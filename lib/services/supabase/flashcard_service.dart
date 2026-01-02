import 'package:supabase_flutter/supabase_flutter.dart';
import './supabase_service.dart';

class FlashcardService {
  Future<PostgrestList> getFlashCardSets() async {
    return await supabase
        .from('flashcard_sets')
        .select()
        .order('created_at', ascending: true);
  }

  Future<int> getFlashCardCount(String setId) async {
    final response = await supabase
        .from('flashcards')
        .select('id')
        .eq('set_id', setId);
    return response.length;
  }

  Future<PostgrestList> getFlashCards(String flashCardSet) async {
    return await supabase
        .from('flashcards')
        .select()
        .eq('set_id', flashCardSet)
        .order('order_index', ascending: true);
  }

  Future<PostgrestList> getFlashcardsByIds(List<String> flashcardIds) async {
    if (flashcardIds.isEmpty) return <Map<String, dynamic>>[];
    return await supabase
        .from('flashcards')
        .select()
        .inFilter('id', flashcardIds);
  }
}
