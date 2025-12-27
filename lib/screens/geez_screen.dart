import 'package:flutter/material.dart';
import 'package:kemey_app/services/supabase/geez_service.dart';
import 'package:kemey_app/utils/haptics.dart';
import 'package:kemey_app/widgets/letter_card.dart';
import 'package:kemey_app/widgets/letter_variants_modal.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GeezScreen extends StatelessWidget {
  const GeezScreen({super.key});

  static const _headerTextStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 24,
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PostgrestList>(
      future: GeezService.getBaseLetters(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final data = snapshot.data ?? [];

        return CustomScrollView(
          slivers: [_buildHeader(), _buildLetterGrid(context, data)],
        );
      },
    );
  }

  Widget _buildHeader() {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(22.0, 90.0, 16.0, 0),
      sliver: SliverToBoxAdapter(
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text('Base Letters', style: _headerTextStyle),
        ),
      ),
    );
  }

  Widget _buildLetterGrid(BuildContext context, List<dynamic> data) {
    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
          childAspectRatio: 1,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final item = data[index];
          return LetterCard(
            letter: item['letter'].toString(),
            translit: item['translit'].toString(),
            onTap: () {
              selectionClick();
              showModalBottomSheet<void>(
                context: context,
                builder: (context) => LetterVariantsModal(baseLetter: item),
              );
            },
          );
        }, childCount: data.length),
      ),
    );
  }
}
