import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kemey_app/models/flashcard.dart';

class FlashcardFlipCard extends StatefulWidget {
  const FlashcardFlipCard({super.key, required this.flashcard});

  final Flashcard flashcard;

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
                    ? _FlashcardFront(flashcard: widget.flashcard)
                    : Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()..rotateY(math.pi),
                        child: _FlashcardBack(flashcard: widget.flashcard),
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
  const _FlashcardFront({required this.flashcard});

  final Flashcard flashcard;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('front'),
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            CupertinoIcons.square_stack_3d_up,
            size: 48,
            color: Color.fromARGB(255, 255, 128, 0),
          ),
          const SizedBox(height: 32),
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
    );
  }
}

class _FlashcardBack extends StatelessWidget {
  const _FlashcardBack({required this.flashcard});

  final Flashcard flashcard;

  @override
  Widget build(BuildContext context) {
    return Container(
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            CupertinoIcons.checkmark_seal_fill,
            size: 48,
            color: Colors.white,
          ),
          const SizedBox(height: 32),
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
    );
  }
}
