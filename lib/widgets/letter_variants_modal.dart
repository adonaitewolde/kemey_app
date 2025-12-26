import 'package:flutter/material.dart';
import 'package:kemey_app/services/supabase/geez_service.dart';
import 'package:kemey_app/widgets/letter_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LetterVariantsModal extends StatelessWidget {
  final Map<String, dynamic> baseLetter;

  const LetterVariantsModal({super.key, required this.baseLetter});

  static const _headerTextStyle = TextStyle(
    fontFamily: 'NotoSansEthiopic',
    fontSize: 60,
    color: Color.fromARGB(255, 238, 106, 18),
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PostgrestList>(
      future: GeezService.getBaseLetterVariants(
        baseLetter['base_letter'].toString(),
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 300,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final forms = snapshot.data ?? [];

        return SizedBox(
          height: 400,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(baseLetter['letter'].toString(), style: _headerTextStyle),
                const SizedBox(height: 40),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                          childAspectRatio: 1,
                        ),
                    itemCount: forms.length,
                    itemBuilder: (context, idx) {
                      final form = forms[idx];
                      return LetterCard(
                        letter: form['letter'].toString(),
                        translit: form['translit'].toString(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
