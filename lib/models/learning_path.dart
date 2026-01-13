import 'package:flutter/foundation.dart';

@immutable
class UserStats {
  const UserStats({
    required this.id,
    required this.totalXp,
    required this.currentStreak,
    required this.longestStreak,
    this.lastActivityDate,
    this.currentUnitId,
    this.currentSectionId,
  });

  final String id;
  final int totalXp;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastActivityDate;
  final String? currentUnitId;
  final String? currentSectionId;

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      id: json['id'] as String,
      totalXp: json['total_xp'] as int? ?? 0,
      currentStreak: json['current_streak'] as int? ?? 0,
      longestStreak: json['longest_streak'] as int? ?? 0,
      lastActivityDate: json['last_activity_date'] != null
          ? DateTime.parse(json['last_activity_date'] as String)
          : null,
      currentUnitId: json['current_unit_id'] as String?,
      currentSectionId: json['current_section_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'total_xp': totalXp,
      'current_streak': currentStreak,
      'longest_streak': longestStreak,
      'last_activity_date': lastActivityDate?.toIso8601String(),
      'current_unit_id': currentUnitId,
      'current_section_id': currentSectionId,
    };
  }
}

@immutable
class Unit {
  const Unit({
    required this.id,
    required this.orderIndex,
    required this.title,
    this.description,
    this.status = 'locked',
    this.sectionsCompleted = 0,
    this.totalSections = 0,
    this.crownLevel = 0,
  });

  final String id;
  final int orderIndex;
  final String title;
  final String? description;
  final String status;
  final int sectionsCompleted;
  final int totalSections;
  final int crownLevel;

  double get progress =>
      totalSections > 0 ? sectionsCompleted / totalSections : 0.0;

  bool get isLocked => status == 'locked';
  bool get isInProgress => status == 'in_progress';
  bool get isCompleted => status == 'completed';
  bool get isMastered => status == 'mastered';

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      id: json['id'] as String,
      orderIndex: json['order_index'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      status: json['status'] as String? ?? 'locked',
      sectionsCompleted: json['sections_completed'] as int? ?? 0,
      totalSections: json['total_sections'] as int? ?? 0,
      crownLevel: json['crown_level'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_index': orderIndex,
      'title': title,
      'description': description,
      'status': status,
      'sections_completed': sectionsCompleted,
      'total_sections': totalSections,
      'crown_level': crownLevel,
    };
  }
}

@immutable
class LearningPath {
  const LearningPath({required this.user, required this.units});

  final UserStats user;
  final List<Unit> units;

  factory LearningPath.fromJson(Map<String, dynamic> json) {
    return LearningPath(
      user: UserStats.fromJson(json['user'] as Map<String, dynamic>),
      units: (json['units'] as List)
          .map((u) => Unit.fromJson(u as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'units': units.map((u) => u.toJson()).toList(),
    };
  }
}
