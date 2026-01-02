import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kemey_app/providers/flashcards_provider.dart';
import 'package:kemey_app/providers/flashcard_progress_provider.dart';

part 'flashcard_set_progress_provider.g.dart';

@riverpod
Future<double> flashcardSetProgress(
  Ref ref,
  String setId,
) async {
  final cards = await ref.watch(flashcardsProvider(setId).future);
  if (cards.isEmpty) return 0.0;

  final progressMap = await ref
      .watch(flashcardProgressControllerProvider(setId).future);

  final learnedCount = cards.where((c) {
    final p = progressMap[c.id];
    return (p?.repetitions ?? 0) > 0;
  }).length;

  return learnedCount / cards.length;
}


