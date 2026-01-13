import 'package:flutter/material.dart';
import 'package:kemey_app/models/learning_path.dart';
import 'package:kemey_app/widgets/unit_node.dart';

class LearningPathView extends StatelessWidget {
  const LearningPathView({
    super.key,
    required this.units,
    required this.userStats,
  });

  final List<Unit> units;
  final UserStats userStats;

  /// Calculate horizontal offset for zig-zag pattern
  /// Pattern: middle → right → more right → right → middle → left → more left → left
  double _getHorizontalOffset(int index) {
    final pattern = [0.0, 0.425, 0.75, 0.425, 0.0, -0.425, -0.75, -0.425];
    return pattern[index % 8];
  }

  @override
  Widget build(BuildContext context) {
    if (units.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.school_outlined, size: 80, color: Colors.grey[400]),
              const SizedBox(height: 16),
              const Text(
                'No learning content available yet',
                style: TextStyle(fontSize: 18, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final unit = units[index];
              final horizontalOffset = _getHorizontalOffset(index);

              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Align(
                  alignment: Alignment(horizontalOffset, 0.0),
                  child: UnitNode(unit: unit),
                ),
              );
            }, childCount: units.length),
          ),
        ),
      ],
    );
  }
}
