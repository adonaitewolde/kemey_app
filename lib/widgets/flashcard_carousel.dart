import 'package:flutter/material.dart';

class FlashCardCarousel extends StatelessWidget {
  const FlashCardCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 450),
        child: CarouselView(
          itemExtent: 330,
          shrinkExtent: 200,
          children: List<Widget>.generate(4, (int index) {
            return UncontainedLayoutCard(index: index, label: 'Set $index');
          }),
        ),
      ),
    );
  }
}

class UncontainedLayoutCard extends StatelessWidget {
  const UncontainedLayoutCard({
    super.key,
    required this.index,
    required this.label,
  });

  final int index;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 255, 123, 0),
      elevation: 8,
      shadowColor: Colors.black.withValues(alpha: 0.25),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 20),
          overflow: TextOverflow.clip,
          softWrap: false,
        ),
      ),
    );
  }
}
