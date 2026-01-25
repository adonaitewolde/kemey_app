import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kemey_app/models/flashcard_set.dart';
import 'package:kemey_app/providers/flashcard_carousel_provider.dart';
import 'package:kemey_app/providers/flashcard_sets_provider.dart';
import 'package:kemey_app/providers/flashcard_set_progress_provider.dart';
import 'package:kemey_app/screens/flashcard_detail_screen.dart';
import 'package:kemey_app/theme/app_theme.dart';
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
            Container(
              height: 245,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFFF5F5F7),
                    const Color(0xFFF5F5F7).withValues(alpha: 0.3),
                  ],
                ),
              ),
              child: PageView.builder(
                controller: pageController,
                onPageChanged: onPageChanged,
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  final progressAsync = ref.watch(
                    flashcardSetProgressProvider(sets[index].id),
                  );

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(8, 10, 8, 20),
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
      child: Material(
        color: Colors.white,
        elevation: 6,
        shadowColor: Colors.black.withValues(alpha: 0.12),
        shape: RoundedSuperellipseBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: InkWell(
          onTap: onTap,
          customBorder: RoundedSuperellipseBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: (textTheme.titleLarge ?? const TextStyle())
                          .copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.5,
                            fontSize: 24,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: (textTheme.bodyMedium ?? const TextStyle())
                          .copyWith(
                            color: Colors.black.withValues(alpha: 0.6),
                            fontSize: 15,
                            height: 1.4,
                            letterSpacing: -0.2,
                          ),
                    ),
                    const Spacer(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _ProgressCircle(progress: progress),
                        const Spacer(),
                        _PlayButton(),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          CupertinoIcons.square_stack_3d_up,
                          size: 14,
                          color: Colors.black.withValues(alpha: 0.5),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$cardCount',
                          style: TextStyle(
                            color: Colors.black.withValues(alpha: 0.6),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ],
                    ),
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

class _ProgressCircle extends StatelessWidget {
  const _ProgressCircle({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final clamped = progress.clamp(0.0, 1.0);

    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(80, 80),
            painter: _ProgressPainter(progress: clamped),
          ),
          Text(
            '${(clamped * 100).toInt()}%',
            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.8),
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.3,
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
    final radius = (size.width / 2) - 5;
    const strokeWidth = 8.0;

    final backgroundPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    final progressPaint = Paint()
      ..color = AppColors.primaryOrange
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
  bool shouldRepaint(_ProgressPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _PlayButton extends StatelessWidget {
  const _PlayButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primaryOrange,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(CupertinoIcons.play_fill, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          const Text(
            'Start',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 15,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }
}
