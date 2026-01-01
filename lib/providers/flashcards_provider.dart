import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kemey_app/models/flashcard.dart';
import 'package:kemey_app/providers/flashcard_service_provider.dart';

part 'flashcards_provider.g.dart';

@riverpod
Future<List<Flashcard>> flashcards(FlashcardsRef ref, String setId) async {
  final service = ref.watch(flashcardServiceProvider);
  final response = await service.getFlashCards(setId);

  return response
      .map((row) => Flashcard.fromJson(Map<String, dynamic>.from(row as Map)))
      .toList();
}
