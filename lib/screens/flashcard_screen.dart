import 'package:flutter/material.dart';
import 'package:kemey_app/widgets/flashcard_carousel.dart';

class FlashcardScreen extends StatelessWidget {
  const FlashcardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100, 0, 0),
      child: const FlashCardCarousel(),
    );
  }
}
