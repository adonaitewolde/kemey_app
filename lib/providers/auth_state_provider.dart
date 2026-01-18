import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_service_provider.dart';

part 'auth_state_provider.g.dart';

/// Stream provider for authentication state changes
///
/// Emits a new AuthState whenever the user signs in, signs out, or session changes
@Riverpod(keepAlive: true)
Stream<AuthState> authStateChanges(Ref ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
}

/// Provider for the current authenticated user
///
/// Returns null if no user is signed in
@Riverpod(keepAlive: true)
User? currentUser(Ref ref) {
  final authState = ref.watch(authStateChangesProvider).value;
  return authState?.session?.user;
}

/// Provider to check if user is authenticated (excludes anonymous users)
///
/// Returns true only if user is signed in with a real account (not anonymous)
@riverpod
bool isAuthenticated(Ref ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return false;

  // Check if user is anonymous
  // Anonymous users have 'anon' in their app_metadata
  final isAnonymous = user.appMetadata['provider'] == 'anonymous';
  return !isAnonymous;
}

/// Provider for user's display name
///
/// Returns name from user metadata or email username as fallback
@riverpod
String? userDisplayName(Ref ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;

  // Try to get name from user metadata (OAuth providers)
  final userMetadata = user.userMetadata;
  if (userMetadata != null) {
    // Google provides 'full_name' or 'name'
    final fullName = userMetadata['full_name'] ?? userMetadata['name'];
    if (fullName != null && fullName.toString().isNotEmpty) {
      return fullName.toString();
    }

    // Apple provides 'name' object with 'firstName' and 'lastName'
    if (userMetadata['name'] is Map) {
      final nameMap = userMetadata['name'] as Map;
      final firstName = nameMap['firstName'];
      final lastName = nameMap['lastName'];
      if (firstName != null || lastName != null) {
        return '${firstName ?? ''} ${lastName ?? ''}'.trim();
      }
    }
  }

  // Fallback to email username
  if (user.email != null) {
    return user.email!.split('@').first;
  }

  return 'User';
}

/// Provider for user's email address
@riverpod
String? userEmail(Ref ref) {
  final user = ref.watch(currentUserProvider);
  return user?.email;
}

/// Provider for user's avatar URL
///
/// Returns avatar URL from OAuth provider or null
@riverpod
String? userAvatarUrl(Ref ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;

  // Try to get avatar from user metadata
  final userMetadata = user.userMetadata;
  if (userMetadata != null) {
    // Google provides 'avatar_url' or 'picture'
    final avatarUrl = userMetadata['avatar_url'] ?? userMetadata['picture'];
    if (avatarUrl != null && avatarUrl.toString().isNotEmpty) {
      return avatarUrl.toString();
    }
  }

  return null;
}
