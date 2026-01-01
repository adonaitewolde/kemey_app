import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kemey_app/services/supabase/flashcard_service.dart';

part 'flashcard_service_provider.g.dart';

/// Dependency injection for [FlashcardService].
///
/// Keeping this as a provider makes it easy to replace/mocked in tests and
/// avoids scattered `FlashcardService()` instantiations across providers.
@Riverpod(keepAlive: true)
FlashcardService flashcardService(FlashcardServiceRef ref) {
  return FlashcardService();
}
