import 'package:supabase_flutter/supabase_flutter.dart';

/// Utility class to convert authentication errors into user-friendly messages
class AuthErrorHandler {
  /// Converts various error types into user-friendly messages
  ///
  /// Handles:
  /// - AuthException with specific status codes
  /// - User initialization errors
  /// - User cancellation
  /// - Network errors
  /// - Generic exceptions
  static String getUserFriendlyMessage(dynamic error) {
    // Handle user initialization errors
    if (error is Exception &&
        error.toString().contains('Failed to initialize user')) {
      // Check if it's a network error during initialization
      if (error.toString().contains('network') ||
          error.toString().contains('timeout') ||
          error.toString().contains('connection')) {
        return 'Network error during account setup. Please check your connection and try again.';
      }

      // Check if it's a timeout during initialization
      if (error.toString().contains('timeout')) {
        return 'Account setup is taking longer than expected. Please try again.';
      }

      // Generic initialization error
      return 'Failed to set up your account. Please try signing in again.';
    }

    // Handle AuthException with status codes
    if (error is AuthException) {
      final statusCode = error.statusCode;

      // Check for common error messages
      final message = error.message.toLowerCase();

      // User cancelled sign-in
      if (message.contains('cancel')) {
        return 'Sign-in cancelled';
      }

      // Handle specific status codes
      switch (statusCode) {
        case '400':
          return 'Invalid request. Please check your input.';

        case '401':
          return 'Authentication failed. Please try again.';

        case '422':
          return 'Unable to process your request. Please try again.';

        case '429':
          return 'Too many attempts. Please wait a moment and try again.';

        case '500':
        case '502':
        case '503':
          return 'Server error. Please try again later.';
      }

      // Return the original message if it's reasonably short
      if (error.message.length < 100) {
        return error.message;
      }

      return 'Authentication failed. Please try again.';
    }

    // Handle network errors
    if (error.toString().toLowerCase().contains('network')) {
      return 'Network error. Please check your connection.';
    }

    // Handle timeout errors
    if (error.toString().toLowerCase().contains('timeout')) {
      return 'Request timed out. Please try again.';
    }

    // Generic error
    return 'An unexpected error occurred. Please try again.';
  }

  /// Check if error is due to user cancellation
  static bool isCancellation(dynamic error) {
    if (error is AuthException) {
      return error.message.toLowerCase().contains('cancel');
    }
    return false;
  }

  /// Check if error is network related
  static bool isNetworkError(dynamic error) {
    final errorStr = error.toString().toLowerCase();
    return errorStr.contains('network') ||
        errorStr.contains('connection') ||
        errorStr.contains('timeout');
  }

  /// Check if error is user initialization related
  static bool isInitializationError(dynamic error) {
    if (error is Exception) {
      return error.toString().contains('Failed to initialize user');
    }
    return false;
  }
}
