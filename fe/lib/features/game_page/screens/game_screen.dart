import 'package:flutter/material.dart';
import '../widgets/game_page_widget.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      body: SafeArea(
        child: Column(
          children: [
            const GameHeader(),
            const SizedBox(height: 10),

            GameBackButton(onTap: () => Navigator.pop(context)),
            const SizedBox(height: 20),

            const GameStatsRow(targetWord: 'KUCING', time: '00:45'),
            const SizedBox(height: 20),

            const PlayCard(),
            const SizedBox(height: 24),

            const InstructionBadge(),
            const Spacer(),

            TransmitButton(
              onTapDown: () {
                // Logic saat tombol ditekan (mulai hitung durasi untuk Tahan / Long)
                print("Ditekan!");
              },
              onTapUp: () {
                // Logic saat dilepas (cek durasi apakah Short atau Long)
                print("Dilepas!");
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
