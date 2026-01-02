import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset('assets/icons/flame.svg', width: 26, height: 26),
            const SizedBox(width: 8),
            const Text('2', style: TextStyle(fontSize: 20)),
            const SizedBox(width: 24),
            SvgPicture.asset(
              'assets/icons/coffee_bean.svg',
              width: 26,
              height: 26,
            ),
            const SizedBox(width: 8),
            const Text('225', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
      body: const Center(child: Text('Hello World!')),
    );
  }
}
