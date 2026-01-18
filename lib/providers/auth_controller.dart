import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'auth_service_provider.dart';
import '../utils/auth_error_handler.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<void> build() {
    // No initial state needed
  }

  /// Sign in with Google
  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();

    try {
      final authService = ref.read(authServiceProvider);
      await authService.signInWithGoogle();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      final message = AuthErrorHandler.getUserFriendlyMessage(e);
      state = AsyncValue.error(message, st);
    }
  }

  Future<void> signInWithApple() async {
    state = const AsyncValue.loading();

    try {
      final authService = ref.read(authServiceProvider);
      await authService.signInWithApple();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      final message = AuthErrorHandler.getUserFriendlyMessage(e);
      state = AsyncValue.error(message, st);
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();

    try {
      final authService = ref.read(authServiceProvider);
      await authService.signOut();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      final message = AuthErrorHandler.getUserFriendlyMessage(e);
      state = AsyncValue.error(message, st);
    }
  }
}
