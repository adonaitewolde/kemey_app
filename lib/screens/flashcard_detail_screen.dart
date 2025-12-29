import 'package:flutter/material.dart';
import 'package:kemey_app/models/flashcard_set.dart';

/// Detail screen for a flashcard set.
/// Currently empty — ready for future implementation.
class FlashcardDetailScreen extends StatelessWidget {
  const FlashcardDetailScreen({super.key, required this.flashcardSet});

  final FlashcardSet flashcardSet;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(flashcardSet.title)),
      body: const SizedBox.shrink(),
    );
  }
}
