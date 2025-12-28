import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kemey_app/models/flashcard_set.dart';
import 'package:kemey_app/providers/flashcard_carousel_provider.dart';
import 'package:kemey_app/providers/flashcard_sets_provider.dart';
import 'package:kemey_app/utils/haptics.dart';
import 'package:kemey_app/services/flashcard.dart';

class FlashCardCarousel extends ConsumerWidget {
  const FlashCardCarousel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = ref.watch(flashcardCarouselCurrentPageProvider);
    final setsAsync = ref.watch(flashcardSetsProvider);

    return setsAsync.when(
      data: (sets) {
        final itemCount = sets.length;
        final safeCurrentPage = itemCount == 0
            ? 0
            : currentPage.clamp(0, itemCount - 1);

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 250),
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification notification) {
                    if (notification is ScrollUpdateNotification) {
                      final position = notification.metrics.pixels;
                      final itemExtent = 330.0;
                      final newPage = (position / itemExtent).round();
                      if (newPage != safeCurrentPage &&
                          newPage >= 0 &&
                          newPage < itemCount) {
                        selectionClick();
                        ref
                            .read(flashcardCarouselCurrentPageProvider.notifier)
                            .setPage(newPage);
                      }
                    }
                    return false;
                  },
                  child: CarouselView(
                    itemExtent: 330,
                    shrinkExtent: 200,
                    children: List<Widget>.generate(itemCount, (int index) {
                      return FlashcardSetCard(
                        set: sets[index],
                        isActive: index == safeCurrentPage,
                        onTap: () async {
                          await mediumImpact();
                        },
                      );
                    }),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            buildPageIndicators(context, safeCurrentPage, itemCount),
          ],
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text('Error loading flashcard sets: $error'),
        ),
      ),
    );
  }
}

class FlashcardSetCard extends StatelessWidget {
  const FlashcardSetCard({
    super.key,
    required this.set,
    required this.isActive,
    this.onTap,
  });

  final FlashcardSet set;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final title = set.title;
    final description = set.description;
    final cardCount = set.cardCount;

    return AnimatedScale(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      scale: isActive ? 1.0 : 0.98,
      child: Material(
        color: const Color.fromARGB(255, 255, 128, 0),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(28),
          child: Ink(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(28)),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.16),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.16),
                              ),
                            ),
                            child: const Icon(
                              Icons.collections_bookmark_rounded,
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: (textTheme.titleLarge ?? const TextStyle())
                            .copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                            ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: (textTheme.bodyMedium ?? const TextStyle())
                            .copyWith(
                              color: Colors.white.withValues(alpha: 0.85),
                              height: 1.15,
                            ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          _Stat(
                            icon: CupertinoIcons.rectangle_stack,
                            label: '$cardCount cards',
                          ),
                          const SizedBox(width: 12),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.white.withValues(alpha: 0.9)),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.9),
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
