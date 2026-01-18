import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  User? get currentUser => _supabase.auth.currentUser;

  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  Future<User?> signInWithGoogle() async {
    try {
      debugPrint('🔐 Starting Google Sign-In flow...');

      final webClientId = dotenv.env['GOOGLE_WEB_CLIENT_ID'];
      final iosClientId = dotenv.env['GOOGLE_IOS_CLIENT_ID'];

      if (webClientId == null || iosClientId == null) {
        throw const AuthException(
          'Google OAuth credentials not configured. Check .env file.',
        );
      }

      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: iosClientId,
        serverClientId: webClientId,
      );

      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        debugPrint('⚠️ Google Sign-In cancelled by user');
        throw const AuthException('Sign-in cancelled');
      }

      debugPrint('✅ Google user signed in: ${googleUser.email}');

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) {
        throw const AuthException('No Access Token found.');
      }
      if (idToken == null) {
        throw const AuthException('No ID Token found.');
      }

      debugPrint('🔑 Got Google tokens, signing in to Supabase...');

      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      debugPrint('✅ Successfully signed in to Supabase with Google');
      return response.user;
    } catch (e) {
      debugPrint('❌ Google Sign-In error: $e');
      rethrow;
    }
  }

  Future<User?> signInWithApple() async {
    try {
      debugPrint('🍎 Starting Apple Sign-In flow...');

      // Generate a secure random nonce for Apple Sign-In
      final rawNonce = _generateNonce();
      final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

      // Trigger the Apple Sign-In flow
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );

      final idToken = credential.identityToken;
      if (idToken == null) {
        throw const AuthException('No ID Token received from Apple');
      }

      debugPrint('🔑 Got Apple token, signing in to Supabase...');

      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.apple,
        idToken: idToken,
        nonce: rawNonce,
      );

      debugPrint('✅ Successfully signed in to Supabase with Apple');
      return response.user;
    } on SignInWithAppleAuthorizationException catch (e) {
      debugPrint('⚠️ Apple Sign-In cancelled or failed: ${e.code}');

      if (e.code == AuthorizationErrorCode.canceled) {
        throw const AuthException('Sign-in cancelled');
      }

      throw AuthException('Apple Sign-In failed: ${e.message}');
    } catch (e) {
      debugPrint('❌ Apple Sign-In error: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      debugPrint('👋 Signing out...');

      await _supabase.auth.signOut();

      debugPrint('✅ Successfully signed out');
    } catch (e) {
      debugPrint('❌ Sign out error: $e');
      rethrow;
    }
  }

  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }
}
