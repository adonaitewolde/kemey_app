import 'package:flutter/material.dart';

class GeezScreen extends StatelessWidget {
  const GeezScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.text_fields, size: 64),
          SizedBox(height: 16),
          Text('Geez'),
        ],
      ),
    );
  }
}
