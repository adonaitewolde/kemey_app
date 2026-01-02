import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
PageController flashcardCarouselPageController(Ref ref) {
  final initialPage = ref.watch(flashcardCarouselCurrentPageProvider);
  final controller = PageController(
    viewportFraction: 0.85,
    initialPage: initialPage,
  );

  ref.onDispose(() => controller.dispose());

  return controller;
}
