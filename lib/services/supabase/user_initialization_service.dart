import 'dart:developer' as developer;
import './supabase_service.dart';

/// Service responsible for initializing user records in the database after authentication
///
/// This service ensures that a user record exists in the database and that
/// initial progress data is set up correctly. It's designed to be called
/// immediately after successful OAuth authentication.
class UserInitializationService {
  /// Ensures the current user is properly initialized in the database
  ///
  /// This method:
  /// - Calls the `initialize_user_progress` RPC function
  /// - Implements retry logic with exponential backoff for network errors
  /// - Is idempotent (safe to call multiple times)
  /// - Returns initialization results
  ///
  /// Throws an exception if initialization fails after all retry attempts
  Future<Map<String, dynamic>> ensureUserInitialized() async {
    final currentUser = supabase.auth.currentUser;
    if (currentUser == null) {
      throw Exception('User not authenticated. Cannot initialize user data.');
    }

    developer.log(
      'Starting user initialization for user: ${currentUser.id}',
      name: 'UserInitializationService',
    );

    // Retry configuration
    const maxAttempts = 3;
    const retryDelays = [
      Duration(seconds: 1),
      Duration(seconds: 2),
      Duration(seconds: 4),
    ];

    Exception? lastError;

    for (int attempt = 0; attempt < maxAttempts; attempt++) {
      try {
        developer.log(
          'Initialization attempt ${attempt + 1} of $maxAttempts',
          name: 'UserInitializationService',
        );

        final response = await supabase.rpc(
          'initialize_user_progress',
          params: {'p_auth_user_id': currentUser.id},
        );

        developer.log(
          'User initialization successful',
          name: 'UserInitializationService',
        );

        return response as Map<String, dynamic>;
      } catch (e) {
        lastError = e is Exception ? e : Exception(e.toString());

        developer.log(
          'Initialization attempt ${attempt + 1} failed: $e',
          name: 'UserInitializationService',
          error: e,
        );

        // Check if error is retryable
        if (!_isRetryableError(e)) {
          developer.log(
            'Error is not retryable, throwing immediately',
            name: 'UserInitializationService',
          );
          throw Exception('Failed to initialize user: $e');
        }

        // If this isn't the last attempt, wait before retrying
        if (attempt < maxAttempts - 1) {
          final delay = retryDelays[attempt];
          developer.log(
            'Waiting ${delay.inSeconds}s before retry...',
            name: 'UserInitializationService',
          );
          await Future.delayed(delay);
        }
      }
    }

    // All attempts failed
    developer.log(
      'All initialization attempts failed',
      name: 'UserInitializationService',
      error: lastError,
    );

    throw Exception(
      'Failed to initialize user after $maxAttempts attempts: $lastError',
    );
  }

  /// Determines if an error is retryable (network/timeout issues)
  ///
  /// Retryable errors:
  /// - Network errors
  /// - Timeout errors
  /// - Connection errors
  ///
  /// Non-retryable errors:
  /// - Authentication errors
  /// - Permission errors
  /// - Constraint violations
  /// - Already initialized (should return success, not retry)
  bool _isRetryableError(dynamic error) {
    final errorStr = error.toString().toLowerCase();

    // Network-related errors are retryable
    if (errorStr.contains('network') ||
        errorStr.contains('timeout') ||
        errorStr.contains('connection') ||
        errorStr.contains('socket')) {
      return true;
    }

    // Authentication and permission errors are not retryable
    if (errorStr.contains('auth') ||
        errorStr.contains('permission') ||
        errorStr.contains('constraint') ||
        errorStr.contains('duplicate')) {
      return false;
    }

    // Default to non-retryable for safety
    return false;
  }
}
