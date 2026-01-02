import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> initializeSupabase() async {
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
}

SupabaseClient get supabase => Supabase.instance.client;

Future<void> ensureSignedIn() async {
  if (supabase.auth.currentSession != null) return;
  try {
    await supabase.auth.signInAnonymously();
  } on AuthApiException catch (e) {
    // Many projects disable anonymous auth. Don't crash the app on startup.
    debugPrint(
      '[ensureSignedIn] Anonymous sign-in failed (${e.statusCode}): ${e.message}',
    );
  } catch (e) {
    debugPrint('[ensureSignedIn] Sign-in failed: $e');
  }
}
