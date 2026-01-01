import 'package:flutter/foundation.dart';

@immutable
class Flashcard {
  const Flashcard({
    required this.id,
    required this.setId,
    required this.geezText,
    required this.translit,
    required this.back,
    required this.orderIndex,
    this.mp3Key,
    this.marked = false,
  });

  final String id;
  final String setId;
  final String geezText;
  final String translit;
  final String back;
  final int orderIndex;
  final String? mp3Key;
  final bool marked;

  static String _asString(dynamic v) {
    if (v == null) return '';
    return v.toString();
  }

  static int _asInt(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v?.toString() ?? '') ?? 0;
  }

  static bool _asBool(dynamic v) {
    if (v is bool) return v;
    final s = v?.toString().toLowerCase();
    return s == 'true' || s == '1' || s == 'yes';
  }

  factory Flashcard.fromJson(Map<String, dynamic> json) {
    // Be tolerant: Supabase returns snake_case keys, but allow fallbacks.
    final id = _asString(json['id'] ?? json['uuid']);
    final setId = _asString(json['set_id'] ?? json['setId']);
    final geezText = _asString(
      json['geez_text'] ??
          json['geezText'] ??
          json['front'] ??
          json['text'],
    );
    final translit = _asString(
      json['translit'] ?? json['transliteration'] ?? json['latin'],
    );
    final back = _asString(
      json['back'] ?? json['answer'] ?? json['meaning'] ?? json['definition'],
    );

    return Flashcard(
      id: id,
      setId: setId,
      geezText: geezText,
      translit: translit,
      back: back,
      orderIndex: _asInt(json['order_index'] ?? json['orderIndex']),
      mp3Key: json['mp3_key'] as String?,
      marked: _asBool(json['marked']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'set_id': setId,
      'geez_text': geezText,
      'translit': translit,
      'back': back,
      'order_index': orderIndex,
      'mp3_key': mp3Key,
      'marked': marked,
    };
  }
}

