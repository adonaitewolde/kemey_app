import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/nav_bar_provider.dart';

class CustomNavigationBar extends ConsumerWidget {
  const CustomNavigationBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navigationIndexProvider);

    return NavigationBar(
      selectedIndex: selectedIndex,
      backgroundColor: Colors.transparent,
      indicatorColor: Colors.transparent,
      onDestinationSelected: (index) {
        ref.read(navigationIndexProvider.notifier).setIndex(index);
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(CupertinoIcons.house),
          selectedIcon: Icon(
            CupertinoIcons.house_fill,
            color: Color.fromARGB(255, 255, 120, 2),
          ),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(CupertinoIcons.collections),
          selectedIcon: Icon(
            CupertinoIcons.collections_solid,
            color: Color.fromARGB(255, 255, 120, 2),
          ),
          label: 'Flashcards',
        ),
        NavigationDestination(
          icon: Icon(CupertinoIcons.book),
          selectedIcon: Icon(
            CupertinoIcons.book_fill,
            color: Color.fromARGB(255, 255, 120, 2),
          ),
          label: "Ge'ez",
        ),
        NavigationDestination(
          icon: Icon(CupertinoIcons.person),
          selectedIcon: Icon(
            CupertinoIcons.person_fill,
            color: Color.fromARGB(255, 255, 120, 2),
          ),
          label: 'Profile',
        ),
      ],
    );
  }
}
