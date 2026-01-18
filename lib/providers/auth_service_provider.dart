import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/supabase/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
part 'auth_service_provider.g.dart';

/// Kept alive throughout the app lifecycle to maintain authentication state
@Riverpod(keepAlive: true)
AuthService authService(Ref ref) {
  return AuthService();
}
