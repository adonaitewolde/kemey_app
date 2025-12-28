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
