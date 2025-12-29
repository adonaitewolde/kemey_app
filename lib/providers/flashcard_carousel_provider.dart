import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'flashcard_carousel_provider.g.dart';

@riverpod
class FlashcardCarouselCurrentPage extends _$FlashcardCarouselCurrentPage {
  @override
  int build() => 0;

  void setPage(int page) {
    state = page;
  }
}

@riverpod
PageController flashcardCarouselPageController(
  FlashcardCarouselPageControllerRef ref,
) {
  final initialPage = ref.watch(flashcardCarouselCurrentPageProvider);
  final controller = PageController(
    viewportFraction: 0.85,
    initialPage: initialPage,
  );

  // Auto-dispose when provider is disposed
  ref.onDispose(() => controller.dispose());

  return controller;
}
