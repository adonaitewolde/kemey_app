import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:kemey_app/models/flashcard.dart';

class FlashcardFlipCard extends StatefulWidget {
  const FlashcardFlipCard({
    super.key,
    required this.flashcard,
    this.onToggleMarked,
    this.marked = false,
  });

  final Flashcard flashcard;
  final VoidCallback? onToggleMarked;
  final bool marked;

  @override
  State<FlashcardFlipCard> createState() => _FlashcardFlipCardState();
}

class _FlashcardFlipCardState extends State<FlashcardFlipCard>
    with SingleTickerProviderStateMixin {
  bool isFlipped = false;
  late final AnimationController _flipController;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _toggleFlip() {
    setState(() {
      isFlipped = !isFlipped;
    });
    if (isFlipped) {
      _flipController.forward();
    } else {
      _flipController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _toggleFlip,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
        child: AnimatedBuilder(
          animation: CurvedAnimation(
            parent: _flipController,
            curve: Curves.easeInOut,
          ),
          builder: (context, child) {
            final angle = _flipController.value * math.pi;
            final showFront = angle <= (math.pi / 2);

            final transform = Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle);

            return Transform(
              transform: transform,
              alignment: Alignment.center,
              child: Material(
                color: Colors.white,
                elevation: 10,
                shadowColor: Colors.black.withValues(alpha: 0.25),
                shape: RoundedSuperellipseBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                clipBehavior: Clip.antiAlias,
                child: showFront
                    ? _FlashcardFront(
                        flashcard: widget.flashcard,
                        marked: widget.marked,
                        onToggleMarked: widget.onToggleMarked,
                      )
                    : Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()..rotateY(math.pi),
                        child: _FlashcardBack(
                          flashcard: widget.flashcard,
                          marked: widget.marked,
                          onToggleMarked: widget.onToggleMarked,
                        ),
                      ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FlashcardFront extends StatelessWidget {
  const _FlashcardFront({
    required this.flashcard,
    required this.marked,
    required this.onToggleMarked,
  });

  final Flashcard flashcard;
  final bool marked;
  final VoidCallback? onToggleMarked;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          key: const ValueKey('front'),
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Text(
                flashcard.geezText.isNotEmpty ? flashcard.geezText : '—',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'NotoSansEthiopic',
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                flashcard.translit.isNotEmpty ? flashcard.translit : ' ',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              Text(
                'Tap to flip',
                style: TextStyle(fontSize: 14, color: Colors.grey[400]),
              ),
            ],
          ),
        ),
        Positioned(
          top: 24,
          right: 24,
          child: IconButton(
            onPressed: onToggleMarked,
            icon: Icon(
              marked ? Icons.star_rounded : Icons.star_border_rounded,
              size: 40,
            ),
            style: IconButton.styleFrom(
              iconSize: 40,
              foregroundColor: marked
                  ? const Color.fromARGB(255, 255, 128, 0)
                  : Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}

class _FlashcardBack extends StatelessWidget {
  const _FlashcardBack({
    required this.flashcard,
    required this.marked,
    required this.onToggleMarked,
  });

  final Flashcard flashcard;
  final bool marked;
  final VoidCallback? onToggleMarked;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          key: const ValueKey('back'),
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 255, 128, 0),
                Color.fromARGB(255, 255, 100, 0),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Text(
                flashcard.back.isNotEmpty ? flashcard.back : '—',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              Text(
                'Tap to flip',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        Positioned(
          top: 24,
          right: 24,
          child: IconButton(
            onPressed: onToggleMarked,
            icon: Icon(
              marked ? Icons.star_rounded : Icons.star_border_rounded,
              size: 40,
              color: Colors.white,
            ),
            style: IconButton.styleFrom(iconSize: 40),
          ),
        ),
      ],
    );
  }
}
