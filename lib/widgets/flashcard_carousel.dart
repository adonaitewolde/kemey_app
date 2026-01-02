import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kemey_app/models/flashcard_set.dart';
import 'package:kemey_app/providers/flashcard_carousel_provider.dart';
import 'package:kemey_app/providers/flashcard_sets_provider.dart';
import 'package:kemey_app/providers/flashcard_set_progress_provider.dart';
import 'package:kemey_app/screens/flashcard_detail_screen.dart';
import 'package:kemey_app/utils/haptics.dart';
import 'package:kemey_app/widgets/page_indicators.dart';

class FlashCardCarousel extends ConsumerWidget {
  const FlashCardCarousel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = ref.watch(flashcardCarouselCurrentPageProvider);
    final pageController = ref.watch(flashcardCarouselPageControllerProvider);
    final setsAsync = ref.watch(flashcardSetsProvider);

    void onPageChanged(int page) {
      selectionClick();
      ref.read(flashcardCarouselCurrentPageProvider.notifier).setPage(page);
    }

    return setsAsync.when(
      data: (sets) {
        final itemCount = sets.length;
        final safeCurrentPage = itemCount == 0
            ? 0
            : currentPage.clamp(0, itemCount - 1);

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Practice your skills!',

              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontFamily: 'Poppins',
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 225,
              child: PageView.builder(
                controller: pageController,
                onPageChanged: onPageChanged,
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  final progressAsync = ref.watch(
                    flashcardSetProgressProvider(sets[index].id),
                  );

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: FlashcardSetCard(
                      set: sets[index],
                      isActive: index == safeCurrentPage,
                      progress: progressAsync.when(
                        data: (p) => p,
                        loading: () => 0.0,
                        error: (e, st) => 0.0,
                      ),
                      onTap: () async {
                        await mediumImpact();
                        if (!context.mounted) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FlashcardDetailScreen(
                              flashcardSet: sets[index],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
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
    required this.progress,
    this.onTap,
  });

  final FlashcardSet set;
  final bool isActive;
  final double progress;
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
      child: ClipRSuperellipse(
        borderRadius: BorderRadius.circular(32),
        child: Material(
          color: const Color.fromARGB(255, 255, 128, 0),
          child: InkWell(
            onTap: onTap,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      _Stat(
                        icon: CupertinoIcons.rectangle_stack,
                        label: '$cardCount Cards',
                      ),
                    ],
                  ),
                ),
                Positioned(bottom: 16, right: 18, child: _PlayButton()),
                Positioned(
                  bottom: 16,
                  left: 18,
                  child: _ProgressCircle(progress: progress),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressCircle extends StatelessWidget {
  const _ProgressCircle({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final clamped = progress.clamp(0.0, 1.0);

    return SizedBox(
      width: 72,
      height: 72,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(72, 72),
            painter: _ProgressPainter(progress: clamped),
          ),
          Text(
            '${(clamped * 100).toInt()}%',
            style: const TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressPainter extends CustomPainter {
  const _ProgressPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 8;
    const strokeWidth = 8.0;

    final backgroundPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    final progressPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    const startAngle = -90 * (3.14159 / 180);
    final sweepAngle = 2 * 3.14159 * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Stat extends StatelessWidget {
  const _Stat({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
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
      ),
    );
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            CupertinoIcons.play_fill,
            size: 20,
            color: const Color.fromARGB(255, 255, 128, 0),
          ),
          const SizedBox(width: 6),
          Text(
            'Start',
            style: TextStyle(
              color: const Color.fromARGB(255, 255, 128, 0),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
