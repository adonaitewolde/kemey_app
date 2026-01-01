import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:kemey_app/models/flashcard_set.dart';
import 'package:kemey_app/providers/flashcards_provider.dart';
import 'package:kemey_app/widgets/flashcard_flip_card.dart';

class FlashcardDetailScreen extends ConsumerStatefulWidget {
  const FlashcardDetailScreen({super.key, required this.flashcardSet});

  final FlashcardSet flashcardSet;

  @override
  ConsumerState<FlashcardDetailScreen> createState() =>
      _FlashcardDetailScreenState();
}

class _FlashcardDetailScreenState extends ConsumerState<FlashcardDetailScreen> {
  final CardSwiperController controller = CardSwiperController();
  int currentIndex = 0;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final flashcardsAsync = ref.watch(
      flashcardsProvider(widget.flashcardSet.id),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.flashcardSet.title,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: flashcardsAsync.when(
        data: (flashcards) {
          if (flashcards.isEmpty) {
            return const Center(
              child: Text(
                'Keine Karteikarten vorhanden',
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            );
          }

          return Column(
            children: [
              // Progress bar
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(
                      begin: 0.0,
                      end: currentIndex / flashcards.length,
                    ),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    builder: (context, value, child) {
                      return LinearProgressIndicator(
                        value: value,
                        backgroundColor: Colors.grey[300],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color.fromARGB(255, 255, 128, 0),
                        ),
                        minHeight: 6,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Card swiper
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CardSwiper(
                    controller: controller,
                    cardsCount: flashcards.length,
                    numberOfCardsDisplayed: flashcards.length > 2
                        ? 3
                        : flashcards.length,
                    backCardOffset: const Offset(0, 40),
                    padding: const EdgeInsets.all(0),
                    onSwipe: (previousIndex, currentIndex, direction) {
                      setState(() {
                        this.currentIndex = currentIndex ?? previousIndex + 1;
                      });
                      return true;
                    },
                    onEnd: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Fertig! 🎉'),
                          content: const Text(
                            'Du hast alle Karteikarten durchgearbeitet!',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                              child: const Text('Zurück'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                setState(() {
                                  currentIndex = 0;
                                });
                                controller.moveTo(0);
                              },
                              child: const Text('Nochmal'),
                            ),
                          ],
                        ),
                      );
                    },
                    cardBuilder:
                        (context, index, percentThresholdX, percentThresholdY) {
                          return FlashcardFlipCard(
                            key: ValueKey(flashcards[index].id),
                            flashcard: flashcards[index],
                          );
                        },
                  ),
                ),
              ),
              // Action buttons
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Undo button
                    IconButton(
                      onPressed: controller.undo,
                      icon: const Icon(
                        CupertinoIcons.arrow_counterclockwise,
                        size: 32,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.all(16),
                        shape: const CircleBorder(),
                      ),
                    ),
                    // Swipe left (don't know)
                    IconButton(
                      onPressed: () =>
                          controller.swipe(CardSwiperDirection.left),
                      icon: const Icon(
                        CupertinoIcons.xmark,
                        size: 32,
                        color: Colors.red,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.all(20),
                        shape: const CircleBorder(),
                      ),
                    ),
                    // Swipe right (know)
                    IconButton(
                      onPressed: () =>
                          controller.swipe(CardSwiperDirection.right),
                      icon: const Icon(
                        CupertinoIcons.check_mark,
                        size: 32,
                        color: Colors.green,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.all(20),
                        shape: const CircleBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  CupertinoIcons.exclamationmark_triangle,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  'Fehler beim Laden der Karteikarten',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: const TextStyle(color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
