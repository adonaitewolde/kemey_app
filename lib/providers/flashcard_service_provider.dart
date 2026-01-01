import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kemey_app/services/supabase/flashcard_service.dart';

part 'flashcard_service_provider.g.dart';

@Riverpod(keepAlive: true)
FlashcardService flashcardService(FlashcardServiceRef ref) {
  return FlashcardService();
}
