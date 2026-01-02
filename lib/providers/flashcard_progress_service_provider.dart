import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kemey_app/services/supabase/flashcard_progress_service.dart';

part 'flashcard_progress_service_provider.g.dart';

@Riverpod(keepAlive: true)
FlashcardProgressService flashcardProgressService(
  Ref ref,
) {
  return FlashcardProgressService();
}


