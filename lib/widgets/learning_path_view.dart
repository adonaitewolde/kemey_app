import 'package:flutter/material.dart';
import 'package:kemey_app/models/learning_path.dart';
import 'package:kemey_app/utils/haptics.dart' as haptics;
import 'package:kemey_app/widgets/current_unit_header.dart';
import 'package:kemey_app/widgets/unit_node.dart';

class LearningPathView extends StatefulWidget {
  const LearningPathView({
    super.key,
    required this.units,
    required this.userStats,
  });

  final List<Unit> units;
  final UserStats userStats;

  @override
  State<LearningPathView> createState() => _LearningPathViewState();
}

class _LearningPathViewState extends State<LearningPathView> {
  late ScrollController _scrollController;
  late Unit _visibleUnit;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _visibleUnit = widget.userStats.currentUnitId != null
        ? widget.units.firstWhere(
            (unit) => unit.id == widget.userStats.currentUnitId,
            orElse: () => widget.units.first,
          )
        : widget.units.first;
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Header height is 130.0 (from delegate)
    const headerHeight = 130.0;
    final scrollOffset = _scrollController.offset;

    // Calculate which unit is currently visible under the header
    // Each unit has 20px bottom padding, we need to account for the header position
    const unitHeight = 120.0; // Approximate unit node height
    const unitSpacing = 20.0; // Bottom padding between units
    const topPadding = 32.0; // SliverPadding top padding

    // Calculate the index of the unit that should be visible
    final effectiveScroll = scrollOffset + headerHeight - topPadding;
    int visibleIndex = 0;

    if (effectiveScroll > 0) {
      visibleIndex = (effectiveScroll / (unitHeight + unitSpacing)).floor();
      visibleIndex = visibleIndex.clamp(0, widget.units.length - 1);
    }

    final newVisibleUnit = widget.units[visibleIndex];
    if (newVisibleUnit.id != _visibleUnit.id) {
      haptics.selectionClick();
      setState(() {
        _visibleUnit = newVisibleUnit;
      });
    }
  }

  /// Calculate horizontal offset for harmonic wave pattern
  /// Creates a smooth, flowing sine wave for natural movement
  double _getHorizontalOffset(int index) {
    // Sine wave pattern: sin(x * π/4) * 0.65 for harmonic flow
    final pattern = [
      0.0,   // center
      0.46,  // gentle right
      0.65,  // peak right
      0.46,  // gentle right
      0.0,   // center
      -0.46, // gentle left
      -0.65, // peak left
      -0.46, // gentle left
    ];
    return pattern[index % 8];
  }

  @override
  Widget build(BuildContext context) {
    if (widget.units.isEmpty) {
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
      controller: _scrollController,
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          delegate: _CurrentUnitHeaderDelegate(unit: _visibleUnit),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final unit = widget.units[index];
              final horizontalOffset = _getHorizontalOffset(index);

              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Align(
                  alignment: Alignment(horizontalOffset, 0.0),
                  child: UnitNode(unit: unit),
                ),
              );
            }, childCount: widget.units.length),
          ),
        ),
      ],
    );
  }
}

class _CurrentUnitHeaderDelegate extends SliverPersistentHeaderDelegate {
  _CurrentUnitHeaderDelegate({required this.unit});

  final Unit unit;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return CurrentUnitHeader(unit: unit);
  }

  @override
  double get maxExtent => 110.0;

  @override
  double get minExtent => 110.0;

  @override
  bool shouldRebuild(_CurrentUnitHeaderDelegate oldDelegate) {
    return unit != oldDelegate.unit;
  }
}
