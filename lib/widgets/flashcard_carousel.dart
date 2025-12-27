import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kemey_app/providers/flashcard_carousel_provider.dart';
import 'package:kemey_app/utils/haptics.dart';

class FlashCardCarousel extends ConsumerWidget {
  const FlashCardCarousel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = ref.watch(flashcardCarouselCurrentPageProvider);
    final itemCount = ref.watch(flashcardCarouselItemCountProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 450),
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification notification) {
                if (notification is ScrollUpdateNotification) {
                  final position = notification.metrics.pixels;
                  final itemExtent = 330.0;
                  final newPage = (position / itemExtent).round();
                  if (newPage != currentPage &&
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
                  return UncontainedLayoutCard(index: index, label: ' $index');
                }),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildPageIndicators(ref, currentPage, itemCount),
      ],
    );
  }

  Widget _buildPageIndicators(WidgetRef ref, int currentPage, int itemCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        itemCount,
        (index) => _buildIndicator(index == currentPage),
      ),
    );
  }

  Widget _buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive
            ? const Color.fromARGB(255, 255, 123, 0)
            : Colors.grey.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class UncontainedLayoutCard extends StatelessWidget {
  const UncontainedLayoutCard({
    super.key,
    required this.index,
    required this.label,
  });

  final int index;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 255, 123, 0),
      elevation: 8,
      shadowColor: Colors.black.withValues(alpha: 0.25),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 20,
          ),
          overflow: TextOverflow.clip,
          softWrap: false,
        ),
      ),
    );
  }
}
