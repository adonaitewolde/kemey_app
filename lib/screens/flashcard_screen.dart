import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kemey_app/providers/marked_flashcards_provider.dart';
import 'package:kemey_app/screens/flashcard_detail_screen.dart';
import 'package:kemey_app/theme/app_theme.dart';
import 'package:kemey_app/utils/haptics.dart';
import 'package:kemey_app/widgets/flashcard_carousel.dart';

class FlashcardScreen extends ConsumerWidget {
  const FlashcardScreen({super.key});

  static const _headerPadding = EdgeInsets.fromLTRB(22.0, 90.0, 16.0, 0);
  static const _headerTextStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 24,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final markedAsync = ref.watch(markedFlashcardsProvider);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: _headerPadding,
            child: SizedBox(
              width: double.infinity,
              child: Center(
                child: Text('Practice your skills!', style: _headerTextStyle),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: FlashCardCarousel(),
          ),
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
                        color: AppColors.primaryOrange,
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
