import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kemey_app/models/flashcard_set.dart';

part 'flashcard_sets_provider.g.dart';

@Riverpod(keepAlive: true)
List<FlashcardSet> flashcardSets(FlashcardSetsRef ref) {
  // TODO: Replace with Supabase-backed sets.
  return const [
    FlashcardSet(
      id: 'tigrinya-basics',
      title: 'Tigrinya Basics',
      description: 'Alphabet, greetings, essentials',
      cardCount: 48,
      accentColor: Color(0xFF4F46E5), // Indigo
    ),
    FlashcardSet(
      id: 'verbs-1',
      title: 'Verbs — Level 1',
      description: 'Most common verbs + patterns',
      cardCount: 36,
      accentColor: Color(0xFF06B6D4), // Cyan
    ),
    FlashcardSet(
      id: 'food-travel',
      title: 'Food & Travel',
      description: 'Ordering, directions, places',
      cardCount: 28,
      accentColor: Color(0xFF10B981), // Emerald
    ),
    FlashcardSet(
      id: 'geez-letters',
      title: 'Geez Letters',
      description: 'Recognition + writing practice',
      cardCount: 72,
      accentColor: Color(0xFFF97316), // Orange
    ),
  ];
}
