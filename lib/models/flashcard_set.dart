import 'package:flutter/material.dart';

@immutable
class FlashcardSet {
  const FlashcardSet({
    required this.id,
    required this.title,
    required this.description,
    required this.cardCount,
    required this.dueCount,
    required this.accentColor,
  });

  final String id;
  final String title;
  final String description;
  final int cardCount;
  final int dueCount;
  final Color accentColor;
}


