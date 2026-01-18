import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'services/supabase/supabase_service.dart';
import 'screens/home_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/splash_screen.dart';
import 'providers/auth_state_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await initializeSupabase();
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kemey',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey.withValues(alpha: 0.05),
        ),
        useMaterial3: true,
      ),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateAsync = ref.watch(authStateChangesProvider);

    return authStateAsync.when(
      data: (authState) {
        final user = authState.session?.user;

        if (user != null) {
          final isAnonymous = user.appMetadata['provider'] == 'anonymous';
          if (!isAnonymous) {
            return const HomeScreen();
          }
        }

        return const AuthScreen();
      },
      loading: () => const SplashScreen(),
      error: (_, _) => const AuthScreen(),
    );
  }
}
