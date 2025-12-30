import "package:flutter/material.dart";

Widget buildPageIndicators(
  BuildContext context,
  int currentPage,
  int itemCount,
) {
  if (itemCount <= 1) return const SizedBox.shrink();
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(
      itemCount,
      (index) => buildIndicator(context, index == currentPage),
    ),
  );
}

Widget buildIndicator(BuildContext context, bool isActive) {
  final colorScheme = Theme.of(context).colorScheme;
  return AnimatedContainer(
    duration: const Duration(milliseconds: 300),
    margin: const EdgeInsets.symmetric(horizontal: 4),
    height: 8,
    width: isActive ? 20 : 8,
    decoration: BoxDecoration(
      color: isActive
          ? const Color.fromARGB(255, 133, 135, 146)
          : colorScheme.outlineVariant.withValues(alpha: 0.6),
      borderRadius: BorderRadius.circular(4),
    ),
  );
}
