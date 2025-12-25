import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kemey_app/services/supabase/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GeezScreen extends StatelessWidget {
  const GeezScreen({super.key});

  Future<PostgrestList> getGeez() async {
    final data = await supabase
        .from('tigrinya_fidel')
        .select()
        .eq('order_index', 1);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PostgrestList>(
      future: getGeez(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final data = snapshot.data ?? [];

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, // number of columns
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
              childAspectRatio: 1,
            ),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              return Card.outlined(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: BorderSide(
                    color: const Color.fromARGB(255, 206, 210, 220),
                    width: 2,
                  ),
                ),
                color: Colors.white30,
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () {
                    debugPrint("pressed");
                  },
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            item['letter'].toString(),
                            style: GoogleFonts.notoSansEthiopic(
                              textStyle: const TextStyle(fontSize: 30),
                              color: const Color.fromARGB(255, 98, 98, 98),
                            ),
                          ),
                          Text(
                            item['translit'].toString(),
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(fontSize: 14),
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
