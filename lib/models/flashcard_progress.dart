import 'package:flutter/foundation.dart';

@immutable
class FlashcardProgress {
  const FlashcardProgress({
    required this.userId,
    required this.flashcardId,
    required this.rating,
    required this.intervalDays,
    required this.repetitions,
    required this.lastReviewedAt,
    required this.nextReviewAt,
    this.id,
    this.createdAt,
    this.updatedAt,
  });

  final String? id;
  final String userId;
  final String flashcardId;
  final int rating; // 0/1/2 (we currently use 0 and 2)
  final int intervalDays;
  final int repetitions;
  final DateTime lastReviewedAt;
  final DateTime nextReviewAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  static String _asString(dynamic v) => v?.toString() ?? '';

  static int _asInt(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v?.toString() ?? '') ?? 0;
  }

  static DateTime _asDateTime(dynamic v) {
    if (v is DateTime) return v.toUtc();
    final s = v?.toString();
    if (s == null || s.isEmpty) return DateTime.now().toUtc();
    return DateTime.parse(s).toUtc();
  }

  factory FlashcardProgress.fromJson(Map<String, dynamic> json) {
    return FlashcardProgress(
      id: json['id']?.toString(),
      userId: _asString(json['user_id'] ?? json['userId']),
      flashcardId: _asString(json['flashcard_id'] ?? json['flashcardId']),
      rating: _asInt(json['rating']),
      intervalDays: _asInt(json['interval_days'] ?? json['intervalDays']),
      repetitions: _asInt(json['repetitions']),
      lastReviewedAt: _asDateTime(
        json['last_reviewed_at'] ?? json['lastReviewedAt'],
      ),
      nextReviewAt: _asDateTime(json['next_review_at'] ?? json['nextReviewAt']),
      createdAt: json['created_at'] == null
          ? null
          : _asDateTime(json['created_at']),
      updatedAt: json['updated_at'] == null
          ? null
          : _asDateTime(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'user_id': userId,
      'flashcard_id': flashcardId,
      'rating': rating,
      'interval_days': intervalDays,
      'repetitions': repetitions,
      'last_reviewed_at': lastReviewedAt.toIso8601String(),
      'next_review_at': nextReviewAt.toIso8601String(),
    };

    // Only include id if it exists (for updates)
    // For new records, let Supabase generate it via default (gen_random_uuid())
    if (id != null) {
      json['id'] = id;
    }

    return json;
  }

  FlashcardProgress copyWith({
    String? id,
    String? userId,
    String? flashcardId,
    int? rating,
    int? intervalDays,
    int? repetitions,
    DateTime? lastReviewedAt,
    DateTime? nextReviewAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FlashcardProgress(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      flashcardId: flashcardId ?? this.flashcardId,
      rating: rating ?? this.rating,
      intervalDays: intervalDays ?? this.intervalDays,
      repetitions: repetitions ?? this.repetitions,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
      nextReviewAt: nextReviewAt ?? this.nextReviewAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
