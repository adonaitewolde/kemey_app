import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/nav_bar_provider.dart';
import '../widgets/custom_navigation_bar.dart';
import 'flashcard_screen.dart';
import 'geez_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navigationIndexProvider);

    final screens = [
      const HomeContent(),
      const FlashcardScreen(),
      const GeezScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: selectedIndex, children: screens),
      bottomNavigationBar: const CustomNavigationBar(),
    );
  }
}

// Separater Widget für den Home-Inhalt
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Hello World!'));
  }
}
