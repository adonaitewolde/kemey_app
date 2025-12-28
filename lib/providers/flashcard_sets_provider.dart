import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kemey_app/models/flashcard_set.dart';
import 'package:kemey_app/services/supabase/flashcard_service.dart';

part 'flashcard_sets_provider.g.dart';

@Riverpod(keepAlive: true)
Future<List<FlashcardSet>> flashcardSets(FlashcardSetsRef ref) async {
  final service = FlashcardService();
  final response = await service.getFlashCardSets();

  final sets = <FlashcardSet>[];
  for (var i = 0; i < response.length; i++) {
    final data = response[i];
    final setId = data['id'] as String? ?? '';

    final cardCount = await service.getFlashCardCount(setId);

    sets.add(
      FlashcardSet(
        id: setId,
        title: data['title'] as String? ?? '',
        description: data['description'] as String? ?? '',
        cardCount: cardCount,
      ),
    );
  }

  return sets;
}
