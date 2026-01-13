import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kemey_app/models/learning_path.dart';
import 'package:kemey_app/theme/app_theme.dart';
import 'package:kemey_app/utils/haptics.dart';
import 'package:kemey_app/widgets/section_indicators_ring.dart';

class UnitNode extends ConsumerWidget {
  const UnitNode({super.key, required this.unit});

  final Unit unit;

  Future<void> _handleUnitTap(BuildContext context, WidgetRef ref) async {
    // Haptic feedback
    await mediumImpact();

    // Don't allow tapping locked units
    if (unit.isLocked) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Complete previous units to unlock this one'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color backgroundColor;
    Color? borderColor;
    double opacity = 1.0;
    Color ringCompletedColor = AppColors.primaryOrange;
    Color ringRemainingColor = Colors.blueGrey.withValues(alpha: 0.25);

    if (unit.isLocked) {
      backgroundColor = Colors.grey[300]!;
      opacity = 0.6;
      borderColor = null;
    } else if (unit.isCompleted) {
      backgroundColor = AppColors.primaryOrange;
      borderColor = null;
    } else {
      backgroundColor = AppColors.primaryOrange;
    }

    const nodeDiameter = 90.0;
    const ringDiameter = 122.0;

    return InkWell(
      onTap: () => _handleUnitTap(context, ref),
      borderRadius: BorderRadius.circular(50),
      child: Opacity(
        opacity: opacity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // Section indicators ring (Duolingo-style) wrapping the node.
                if (unit.totalSections > 0)
                  SectionIndicatorsRing(
                    totalSections: unit.totalSections,
                    sectionsCompleted: unit.sectionsCompleted,
                    diameter: ringDiameter,
                    completedColor: ringCompletedColor,
                    remainingColor: ringRemainingColor,
                  ),
                Material(
                  color: backgroundColor,
                  shape: const CircleBorder(),
                  child: Container(
                    width: nodeDiameter,
                    height: nodeDiameter,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: borderColor != null
                          ? Border.all(color: borderColor, width: 2)
                          : null,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.star_rounded,
                        color: unit.isLocked ? Colors.grey[700] : Colors.white,
                        size: 48,
                      ),
                    ),
                  ),
                ),
                if (unit.isCompleted)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.all(2),
                      child: const Text('⭐', style: TextStyle(fontSize: 20)),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
