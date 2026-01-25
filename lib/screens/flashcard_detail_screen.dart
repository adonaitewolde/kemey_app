import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:kemey_app/models/flashcard_progress.dart';
import 'package:kemey_app/models/flashcard_set.dart';
import 'package:kemey_app/providers/flashcards_provider.dart';
import 'package:kemey_app/providers/flashcard_progress_provider.dart';
import 'package:kemey_app/providers/marked_flashcards_provider.dart';
import 'package:kemey_app/theme/app_theme.dart';
import 'package:kemey_app/widgets/flashcard_flip_card.dart';
import 'package:kemey_app/utils/haptics.dart';

class FlashcardDetailScreen extends ConsumerStatefulWidget {
  const FlashcardDetailScreen({super.key, required this.flashcardSet})
    : markedOnly = false;

  const FlashcardDetailScreen.marked({super.key})
    : flashcardSet = null,
      markedOnly = true;

  final FlashcardSet? flashcardSet;
  final bool markedOnly;

  @override
  ConsumerState<FlashcardDetailScreen> createState() =>
      _FlashcardDetailScreenState();
}

class _FlashcardDetailScreenState extends ConsumerState<FlashcardDetailScreen> {
  final CardSwiperController controller = CardSwiperController();
  int currentIndex = 0;
  bool _didJumpToStart = false;
  List<String> _removedMarkedIds = <String>[];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  int _computeStartIndex({
    required List<String> flashcardsIdsInOrder,
    required Map<String, FlashcardProgress> progressById,
  }) {
    // Unseen: no progress row
    for (var i = 0; i < flashcardsIdsInOrder.length; i++) {
      final id = flashcardsIdsInOrder[i];
      if (!progressById.containsKey(id)) return i;
    }

    // Due: next_review_at <= now
    final now = DateTime.now().toUtc();
    for (var i = 0; i < flashcardsIdsInOrder.length; i++) {
      final id = flashcardsIdsInOrder[i];
      final p = progressById[id];
      if (p == null) continue;
      if (!p.nextReviewAt.isAfter(now)) return i;
    }

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final flashcardsAsync = widget.markedOnly
        ? ref.watch(markedFlashcardsProvider)
        : ref.watch(flashcardsProvider(widget.flashcardSet!.id));

    final progressAsync = widget.markedOnly
        ? ref.watch(markedFlashcardProgressProvider)
        : ref.watch(
            flashcardProgressControllerProvider(widget.flashcardSet!.id),
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
          widget.markedOnly ? 'Marked cards' : widget.flashcardSet!.title,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: flashcardsAsync.when(
        data: (flashcards) {
          final visibleFlashcards = widget.markedOnly
              ? flashcards
                    .where((c) => !_removedMarkedIds.contains(c.id))
                    .toList()
              : flashcards;

          if (visibleFlashcards.isEmpty) {
            return const Center(
              child: Text(
                'No marked cards',
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            );
          }

          // Jump to the first unseen (or due) card once progress is loaded.
          progressAsync.whenData((progressMap) {
            if (_didJumpToStart) return;
            final ids = visibleFlashcards.map((f) => f.id).toList();

            final startIndex = _computeStartIndex(
              flashcardsIdsInOrder: ids,
              progressById: progressMap,
            );
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_didJumpToStart) return;
              _didJumpToStart = true;
              controller.moveTo(startIndex);
              if (!mounted) return;
              setState(() {
                currentIndex = startIndex;
              });
            });
          });

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(
                      begin: 0.0,
                      end: visibleFlashcards.isEmpty
                          ? 0.0
                          : (currentIndex / visibleFlashcards.length),
                    ),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    builder: (context, value, child) {
                      return LinearProgressIndicator(
                        value: value,
                        backgroundColor: Colors.grey[300],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primaryOrange,
                        ),
                        minHeight: 6,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CardSwiper(
                    controller: controller,
                    cardsCount: visibleFlashcards.length,
                    numberOfCardsDisplayed: visibleFlashcards.length > 2
                        ? 3
                        : visibleFlashcards.length,
                    backCardOffset: const Offset(0, 40),
                    padding: const EdgeInsets.all(0),
                    threshold: 50,
                    duration: const Duration(milliseconds: 275),
                    allowedSwipeDirection: AllowedSwipeDirection.only(
                      left: true,
                      right: true,
                      up: true,
                    ),
                    onSwipe: (previousIndex, currentIndex, direction) {
                      final swipedCard = visibleFlashcards[previousIndex];
                      final swipedCardId = swipedCard.id;
                      final progressController = ref.read(
                        flashcardProgressControllerProvider(
                          swipedCard.setId,
                        ).notifier,
                      );

                      if (direction == CardSwiperDirection.left) {
                        progressController.recordReview(
                          flashcardId: swipedCardId,
                          rating: 0,
                        );
                      } else if (direction == CardSwiperDirection.right) {
                        progressController.recordReview(
                          flashcardId: swipedCardId,
                          rating: 2,
                        );
                      } else if (direction == CardSwiperDirection.top) {
                        progressController.recordReview(
                          flashcardId: swipedCardId,
                          rating: 1,
                        );
                      }

                      setState(() {
                        this.currentIndex = currentIndex ?? previousIndex + 1;
                      });
                      return true;
                    },
                    onEnd: () {
                      Navigator.pop(context);
                    },
                    cardBuilder:
                        (context, index, percentThresholdX, percentThresholdY) {
                          final flashcard = visibleFlashcards[index];
                          final progress =
                              progressAsync.valueOrNull?[flashcard.id];
                          final isMarked = progress?.marked ?? false;

                          return FlashcardFlipCard(
                            key: ValueKey(flashcard.id),
                            flashcard: flashcard,
                            marked: isMarked,
                            onToggleMarked: () async {
                              final controller = ref.read(
                                flashcardProgressControllerProvider(
                                  flashcard.setId,
                                ).notifier,
                              );
                              try {
                                await controller.toggleMarked(
                                  flashcardId: flashcard.id,
                                );
                                if (!mounted) return;

                                // Always invalidate marked cards provider to update count in flashcard_screen
                                ref.invalidate(markedFlashcardsProvider);
                                ref.invalidate(markedFlashcardProgressProvider);

                                // In "marked cards" mode: if user unmarks, remove it from the stack.
                                if (widget.markedOnly && isMarked) {
                                  setState(() {
                                    _removedMarkedIds = List<String>.from(
                                      _removedMarkedIds,
                                    )..add(flashcard.id);
                                  });

                                  final remaining =
                                      visibleFlashcards.length - 1;
                                  if (remaining <= 0 && context.mounted) {
                                    Navigator.pop(context);
                                  }
                                }
                              } catch (e) {
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())),
                                );
                              }
                            },
                          );
                        },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
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
                    IconButton(
                      onPressed: () async {
                        await mediumImpact();
                        controller.swipe(CardSwiperDirection.left);
                      },
                      icon: const Icon(
                        Icons.sentiment_very_dissatisfied,
                        size: 32,
                        color: Colors.red,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.all(20),
                        shape: const CircleBorder(),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await mediumImpact();
                        controller.swipe(CardSwiperDirection.top);
                      },
                      icon: const Icon(
                        Icons.sentiment_neutral,
                        size: 32,
                        color: Colors.orange,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.all(20),
                        shape: const CircleBorder(),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await mediumImpact();
                        controller.swipe(CardSwiperDirection.right);
                      },
                      icon: const Icon(
                        Icons.tag_faces,
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
