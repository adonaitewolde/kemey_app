import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kemey_app/models/flashcard_set.dart';
import 'package:kemey_app/providers/flashcard_service_provider.dart';

part 'flashcard_sets_provider.g.dart';

@Riverpod(keepAlive: true)
Future<List<FlashcardSet>> flashcardSets(Ref ref) async {
  final service = ref.watch(flashcardServiceProvider);
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
