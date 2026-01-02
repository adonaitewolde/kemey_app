import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kemey_app/models/flashcard.dart';
import 'package:kemey_app/models/flashcard_progress.dart';
import 'package:kemey_app/providers/flashcard_progress_service_provider.dart';
import 'package:kemey_app/providers/flashcard_service_provider.dart';

final markedFlashcardsProvider = FutureProvider<List<Flashcard>>((ref) async {
  final progressService = ref.watch(flashcardProgressServiceProvider);
  final service = ref.watch(flashcardServiceProvider);

  final ids = await progressService.getMarkedFlashcardIds();
  if (ids.isEmpty) return [];

  final rows = await service.getFlashcardsByIds(ids);
  final cards = rows
      .map((row) => Flashcard.fromJson(Map<String, dynamic>.from(row as Map)))
      .toList();

  // Stable order for the UX: setId -> orderIndex
  cards.sort((a, b) {
    final bySet = a.setId.compareTo(b.setId);
    if (bySet != 0) return bySet;
    return a.orderIndex.compareTo(b.orderIndex);
  });

  return cards;
});

final markedFlashcardProgressProvider =
    FutureProvider<Map<String, FlashcardProgress>>((ref) async {
  final cards = await ref.watch(markedFlashcardsProvider.future);
  final ids = cards.map((c) => c.id).where((id) => id.isNotEmpty).toList();
  if (ids.isEmpty) return {};

  final service = ref.watch(flashcardProgressServiceProvider);
  return service.getProgressForFlashcardIds(flashcardIds: ids);
});


