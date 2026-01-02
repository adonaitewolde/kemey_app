import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kemey_app/providers/marked_flashcards_provider.dart';
import 'package:kemey_app/screens/flashcard_detail_screen.dart';
import 'package:kemey_app/utils/haptics.dart';
import 'package:kemey_app/widgets/flashcard_carousel.dart';

class FlashcardScreen extends ConsumerWidget {
  const FlashcardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final markedAsync = ref.watch(markedFlashcardsProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100, 0, 0),
      child: Column(
        children: [
          const FlashCardCarousel(),
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () async {
                  await mediumImpact();
                  if (!context.mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const FlashcardDetailScreen.marked(),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Color.fromARGB(255, 255, 128, 0),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Marked cards',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      markedAsync.when(
                        data: (cards) => Text(
                          '${cards.length}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.black54,
                          ),
                        ),
                        loading: () => const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        error: (err, _) => const Icon(
                          Icons.error_outline,
                          color: Colors.black45,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.chevron_right, color: Colors.black54),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
