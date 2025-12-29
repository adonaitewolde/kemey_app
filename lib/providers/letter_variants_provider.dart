import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kemey_app/services/supabase/geez_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'letter_variants_provider.g.dart';

@riverpod
Future<PostgrestList> letterVariants(
  LetterVariantsRef ref,
  String baseLetter,
) async {
  return GeezService.getBaseLetterVariants(baseLetter);
}

