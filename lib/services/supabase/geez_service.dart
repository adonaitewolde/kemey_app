import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GeezService {
  static List<Map<String, dynamic>>? _cachedData;

  static Future<List<Map<String, dynamic>>> _loadData() async {
    if (_cachedData != null) {
      return _cachedData!;
    }

    final String jsonString = await rootBundle.loadString(
      'assets/tigrinya_fidel.json',
    );
    final List<dynamic> jsonData = json.decode(jsonString);
    _cachedData = jsonData.cast<Map<String, dynamic>>();
    return _cachedData!;
  }

  static Future<PostgrestList> getBaseLetters() async {
    final data = await _loadData();
    return data.where((item) => item['order_index'] == 1).toList();
  }

  static Future<PostgrestList> getBaseLetterVariants(String baseLetter) async {
    final data = await _loadData();
    final variants = data
        .where((item) => item['base_letter'] == baseLetter)
        .toList();
    variants.sort(
      (a, b) => (a['order_index'] as int).compareTo(b['order_index'] as int),
    );
    return variants;
  }
}
