import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:kemey_app/theme/app_theme.dart';

class SectionIndicatorsRing extends StatefulWidget {
  const SectionIndicatorsRing({
    super.key,
    required this.totalSections,
    required this.sectionsCompleted,
    required this.diameter,
    this.strokeWidth,
    this.completedColor = AppColors.primaryOrangeDark,
    this.remainingColor = Colors.blueGrey,
    this.enablePulse = true,
  });

  final int totalSections;
  final int sectionsCompleted;
  final double diameter;
  final double? strokeWidth;
  final Color completedColor;
  final Color remainingColor;
  final bool enablePulse;

  @override
  State<SectionIndicatorsRing> createState() => _SectionIndicatorsRingState();
}

class _SectionIndicatorsRingState extends State<SectionIndicatorsRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.enablePulse && widget.sectionsCompleted > 0) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(SectionIndicatorsRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enablePulse &&
        widget.sectionsCompleted > 0 &&
        !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.enablePulse || widget.sectionsCompleted == 0) {
      _controller.stop();
      _controller.value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.totalSections <= 0) return const SizedBox.shrink();

    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: CustomPaint(
          size: Size.square(widget.diameter),
          painter: _SectionIndicatorsRingPainter(
            totalSections: widget.totalSections,
            sectionsCompleted: widget.sectionsCompleted,
            strokeWidth:
                widget.strokeWidth ?? math.max(6, widget.diameter * 0.07),
            completedColor: widget.completedColor,
            remainingColor: widget.remainingColor,
          ),
        ),
      ),
    );
  }
}

class _SectionIndicatorsRingPainter extends CustomPainter {
  _SectionIndicatorsRingPainter({
    required this.totalSections,
    required this.sectionsCompleted,
    required this.strokeWidth,
    required this.completedColor,
    required this.remainingColor,
  });

  final int totalSections;
  final int sectionsCompleted;
  final double strokeWidth;
  final Color completedColor;
  final Color remainingColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (math.min(size.width, size.height) - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final n = totalSections.clamp(1, 64);
    final completed = sectionsCompleted.clamp(0, n);

    // Each indicator is a small arc segment; as n grows, shrink the gap so the
    // ring still reads cleanly.
    final per = 2 * math.pi / n;
    final gap = math.min(0.22, per * 0.35); // radians
    final sweep = (per - gap).clamp(0.04, per);
    final start = -math.pi / 2; // start at top

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < n; i++) {
      paint.color = i < completed ? completedColor : remainingColor;
      final a = start + (i * per) + (gap / 2);
      canvas.drawArc(rect, a, sweep, false, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SectionIndicatorsRingPainter oldDelegate) {
    return totalSections != oldDelegate.totalSections ||
        sectionsCompleted != oldDelegate.sectionsCompleted ||
        strokeWidth != oldDelegate.strokeWidth ||
        completedColor != oldDelegate.completedColor ||
        remainingColor != oldDelegate.remainingColor;
  }
}
