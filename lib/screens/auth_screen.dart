import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../providers/auth_controller.dart';
import '../widgets/auth/google_sign_in_button.dart';
import '../widgets/auth/apple_sign_in_button.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.watch(authControllerProvider);

    ref.listen<AsyncValue<void>>(authControllerProvider, (_, state) {
      if (state.hasError) {
        final error = state.error.toString();

        // Don't show error for user cancellation
        if (!error.toLowerCase().contains('cancel')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 80),

                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/kemey-logo.svg',
                        height: 80,
                        width: 80,
                      ),
                      Text(
                        "Kemey",
                        style: TextStyle(
                          fontFamily: 'Goia',
                          fontSize: 40,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromARGB(255, 68, 39, 33),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),

                // Social Sign-In buttons
                const GoogleSignInButton(),
                const SizedBox(height: 16),
                const AppleSignInButton(),

                const SizedBox(height: 40),

                // Error display area
                if (authController.hasError &&
                    !authController.error.toString().toLowerCase().contains(
                      'cancel',
                    ))
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: ShapeDecoration(
                      color: Colors.red.shade50,
                      shape: RoundedSuperellipseBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.red.shade200),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red.shade700,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            authController.error.toString(),
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
