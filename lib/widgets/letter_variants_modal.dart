import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kemey_app/providers/letter_variants_provider.dart';
import 'package:kemey_app/widgets/letter_card.dart';

class LetterVariantsModal extends ConsumerWidget {
  final Map<String, dynamic> baseLetter;

  const LetterVariantsModal({super.key, required this.baseLetter});

  static const _headerTextStyle = TextStyle(
    fontFamily: 'NotoSansEthiopic',
    fontSize: 60,
    color: Color.fromARGB(255, 238, 106, 18),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final variantsAsync = ref.watch(
      letterVariantsProvider(baseLetter['base_letter'].toString()),
    );

    return variantsAsync.when(
      loading: () => const SizedBox(
        height: 300,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) =>
          SizedBox(height: 300, child: Center(child: Text('Error: $error'))),
      data: (forms) {
        return SizedBox(
          height: 400,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 24),
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 198, 198, 202),
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
                Text(baseLetter['letter'].toString(), style: _headerTextStyle),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    cacheExtent: 200,
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
