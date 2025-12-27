import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kemey_app/models/flashcard_set.dart';
import 'package:kemey_app/providers/flashcard_carousel_provider.dart';
import 'package:kemey_app/providers/flashcard_sets_provider.dart';
import 'package:kemey_app/utils/haptics.dart';

class FlashCardCarousel extends ConsumerWidget {
  const FlashCardCarousel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = ref.watch(flashcardCarouselCurrentPageProvider);
    final sets = ref.watch(flashcardSetsProvider);
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
                            .state =
                        newPage;
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
        _buildPageIndicators(context, safeCurrentPage, itemCount),
      ],
    );
  }

  Widget _buildPageIndicators(
    BuildContext context,
    int currentPage,
    int itemCount,
  ) {
    if (itemCount <= 1) return const SizedBox.shrink();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        itemCount,
        (index) => _buildIndicator(context, index == currentPage),
      ),
    );
  }

  Widget _buildIndicator(BuildContext context, bool isActive) {
    final colorScheme = Theme.of(context).colorScheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive
            ? colorScheme.primary
            : colorScheme.outlineVariant.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(4),
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final accent = set.accentColor;
    final title = set.title;
    final description = set.description;
    final cardCount = set.cardCount;
    final dueCount = set.dueCount;

    final bg = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        accent.withValues(alpha: 0.95),
        accent.withValues(alpha: 0.65),
        colorScheme.surface.withValues(alpha: 0.10),
      ],
      stops: const [0.0, 0.7, 1.0],
    );

    return AnimatedScale(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      scale: isActive ? 1.0 : 0.98,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(28),
          child: Ink(
            decoration: BoxDecoration(
              gradient: bg,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isActive ? 0.22 : 0.14),
                  blurRadius: isActive ? 22 : 16,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
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
                          _DueChip(dueCount: dueCount),
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
                            icon: Icons.style_rounded,
                            label: '$cardCount cards',
                          ),
                          const SizedBox(width: 12),
                          _Stat(
                            icon: Icons.schedule_rounded,
                            label: dueCount == 0 ? 'All done' : '$dueCount due',
                          ),
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

class _DueChip extends StatelessWidget {
  const _DueChip({required this.dueCount});

  final int dueCount;

  @override
  Widget build(BuildContext context) {
    final label = dueCount == 0 ? 'Ready' : '$dueCount due';
    final bg = dueCount == 0
        ? Colors.white.withValues(alpha: 0.18)
        : Colors.black.withValues(alpha: 0.18);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 12,
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
