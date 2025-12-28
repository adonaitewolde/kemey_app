import 'package:flutter/material.dart';

@immutable
class FlashcardSet {
  const FlashcardSet({
    required this.id,
    required this.title,
    required this.description,
    required this.cardCount,
  });

  final String id;
  final String title;
  final String description;
  final int cardCount;
}
