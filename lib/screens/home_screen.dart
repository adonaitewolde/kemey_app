import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../providers/learning_path_provider.dart';
import '../providers/nav_bar_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_navigation_bar.dart';
import '../widgets/learning_path_view.dart';
import 'flashcard_screen.dart';
import 'geez_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const List<Widget> _screens = [
    HomeContent(),
    FlashcardScreen(),
    GeezScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navigationIndexProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: IndexedStack(index: selectedIndex, children: _screens),
      bottomNavigationBar: const CustomNavigationBar(),
    );
  }
}

class HomeContent extends ConsumerWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final learningPathAsync = ref.watch(learningPathProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset('assets/icons/flame.svg', width: 26, height: 26),
              const SizedBox(width: 8),
              const Text(
                '2',
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 38, 43, 46),
                ),
              ),
              const SizedBox(width: 24),
              SvgPicture.asset(
                'assets/icons/coffee_bean.svg',
                width: 26,
                height: 26,
              ),
              const SizedBox(width: 8),
              const Text(
                '225',
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 38, 43, 46),
                ),
              ),
            ],
          ),
        ),
      ),
      body: learningPathAsync.when(
        data: (learningPath) => LearningPathView(
          units: learningPath.units,
          userStats: learningPath.user,
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primaryOrange),
        ),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error loading learning path',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: const TextStyle(color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
