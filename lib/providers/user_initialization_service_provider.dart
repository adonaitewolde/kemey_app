import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/supabase/user_initialization_service.dart';

part 'user_initialization_service_provider.g.dart';

/// Provider for UserInitializationService
///
/// This service is responsible for ensuring user records are properly
/// initialized in the database after authentication
@riverpod
UserInitializationService userInitializationService(Ref ref) {
  return UserInitializationService();
}
