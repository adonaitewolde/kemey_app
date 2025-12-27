import 'package:flutter_riverpod/flutter_riverpod.dart';

final flashcardCarouselCurrentPageProvider = StateProvider<int>((ref) => 0);

final flashcardCarouselItemCountProvider = Provider<int>((ref) => 4);
