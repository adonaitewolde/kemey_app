import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kemey_app/models/flashcard_progress.dart';
import 'package:kemey_app/services/supabase/supabase_service.dart';

class FlashcardProgressService {
  String requireUserId() {
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw const AuthException('User not signed in');
    }
    return user.id;
  }

  Future<Map<String, FlashcardProgress>> getProgressForFlashcardIds({
    required List<String> flashcardIds,
  }) async {
    if (flashcardIds.isEmpty) return {};

    final userId = requireUserId();

    final rows = await supabase
        .from('flashcard_progress')
        .select()
        .eq('user_id', userId)
        .inFilter('flashcard_id', flashcardIds);

    final map = <String, FlashcardProgress>{};
    for (final row in rows) {
      final progress = FlashcardProgress.fromJson(
        Map<String, dynamic>.from(row as Map),
      );
      map[progress.flashcardId] = progress;
    }
    return map;
  }

  Future<FlashcardProgress> upsertProgress(FlashcardProgress progress) async {
    final inserted = await supabase
        .from('flashcard_progress')
        .upsert(progress.toJson(), onConflict: 'user_id,flashcard_id')
        .select()
        .single();

    return FlashcardProgress.fromJson(Map<String, dynamic>.from(inserted));
  }
}
