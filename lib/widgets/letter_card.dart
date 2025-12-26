import 'package:flutter/material.dart';

class LetterCard extends StatelessWidget {
  final String letter;
  final String translit;
  final VoidCallback? onTap;

  const LetterCard({
    super.key,
    required this.letter,
    required this.translit,
    this.onTap,
  });

  static const _letterTextStyle = TextStyle(
    fontFamily: 'NotoSansEthiopic',
    fontSize: 30,
    color: Color.fromARGB(255, 68, 39, 33),
  );

  static const _translitTextStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 14,
    color: Colors.black54,
  );

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(
          color: Color.fromARGB(255, 206, 210, 220),
          width: 2,
        ),
      ),
      color: Colors.white30,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(letter, style: _letterTextStyle),
                Text(translit, style: _translitTextStyle),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
