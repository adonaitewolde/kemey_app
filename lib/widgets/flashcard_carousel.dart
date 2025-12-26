import 'package:flutter/material.dart';


class FlashCardCarousel extends StatefulWidget {
  const FlashCardCarousel({super.key});

  @override
  State<FlashCardCarousel> createState() => _CarouselExampleState();
}

class _CarouselExampleState extends State<FlashCardCarousel> {
  final CarouselController controller = CarouselController(initialItem: 1);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 500),
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
    return Card.outlined(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),

      child: Center(
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 20),
          overflow: TextOverflow.clip,
          softWrap: false,
        ),
      ),
    );
  }
}
