import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kemey_app/models/flashcard.dart';
import 'package:kemey_app/services/supabase/flashcard_service.dart';

part 'flashcards_provider.g.dart';

@riverpod
Future<List<Flashcard>> flashcards(FlashcardsRef ref, String setId) async {
  final response = await FlashcardService.getFlashCards(setId);

  return response
      .map(
        (row) => Flashcard.fromJson(
          Map<String, dynamic>.from(row as Map),
        ),
      )
      .toList();
}

