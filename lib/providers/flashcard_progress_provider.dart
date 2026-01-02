import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kemey_app/models/flashcard_progress.dart';
import 'package:kemey_app/providers/flashcard_progress_service_provider.dart';
import 'package:kemey_app/providers/flashcards_provider.dart';

part 'flashcard_progress_provider.g.dart';

@riverpod
Future<Map<String, FlashcardProgress>> flashcardProgressForSet(
  Ref ref,
  String setId,
) async {
  final cards = await ref.watch(flashcardsProvider(setId).future);
  final ids = cards.map((c) => c.id).where((id) => id.isNotEmpty).toList();
  final service = ref.watch(flashcardProgressServiceProvider);
  return service.getProgressForFlashcardIds(flashcardIds: ids);
}

@riverpod
class FlashcardProgressController extends _$FlashcardProgressController {
  @override
  Future<Map<String, FlashcardProgress>> build(String setId) async {
    return ref.watch(flashcardProgressForSetProvider(setId).future);
  }

  FlashcardProgress _computeNext({
    required String userId,
    required String flashcardId,
    required int rating,
    FlashcardProgress? previous,
  }) {
    final now = DateTime.now().toUtc();

    if (rating == 0) {
      return FlashcardProgress(
        id: previous?.id,
        userId: userId,
        flashcardId: flashcardId,
        rating: 0,
        intervalDays: 0,
        repetitions: 0,
        lastReviewedAt: now,
        nextReviewAt: now,
      );
    }

    final prevInterval = previous?.intervalDays ?? 0;
    final prevReps = previous?.repetitions ?? 0;

    final nextReps = prevReps + 1;
    final nextInterval = prevInterval <= 0 ? 1 : (prevInterval * 2);

    return FlashcardProgress(
      id: previous?.id,
      userId: userId,
      flashcardId: flashcardId,
      rating: 2,
      intervalDays: nextInterval,
      repetitions: nextReps,
      lastReviewedAt: now,
      nextReviewAt: now.add(Duration(days: nextInterval)),
    );
  }

  Future<void> recordReview({
    required String flashcardId,
    required int rating,
  }) async {
    final current = state;
    if (current is! AsyncData<Map<String, FlashcardProgress>>) return;

    final service = ref.read(flashcardProgressServiceProvider);
    final userId = service.requireUserId();

    final oldMap = Map<String, FlashcardProgress>.from(current.value);
    final previous = oldMap[flashcardId];

    final next = _computeNext(
      userId: userId,
      flashcardId: flashcardId,
      rating: rating,
      previous: previous,
    );

    final optimisticMap = Map<String, FlashcardProgress>.from(oldMap)
      ..[flashcardId] = next;

    state = AsyncData(optimisticMap);

    try {
      final saved = await service.upsertProgress(next);
      final withSaved = Map<String, FlashcardProgress>.from(optimisticMap)
        ..[flashcardId] = saved;
      state = AsyncData(withSaved);
    } catch (e, st) {
      state = AsyncError(e, st);
      state = AsyncData(oldMap);
    }
  }
}
