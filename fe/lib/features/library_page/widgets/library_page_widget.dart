import 'package:flutter/material.dart';

// --- DATA MODEL & FACTUAL MORSE DICTIONARY ---
class MorseData {
  final String char;
  final String code;

  MorseData(this.char, this.code);
}

// Data Alfabet A-Z
final List<MorseData> alphabetMorse = [
  MorseData('A', '.-'),
  MorseData('B', '-...'),
  MorseData('C', '-.-.'),
  MorseData('D', '-..'),
  MorseData('E', '.'),
  MorseData('F', '..-.'),
  MorseData('G', '--.'),
  MorseData('H', '....'),
  MorseData('I', '..'),
  MorseData('J', '.---'),
  MorseData('K', '-.-'),
  MorseData('L', '.-..'),
  MorseData('M', '--'),
  MorseData('N', '-.'),
  MorseData('O', '---'),
  MorseData('P', '.--.'),
  MorseData('Q', '--.-'),
  MorseData('R', '.-.'),
  MorseData('S', '...'),
  MorseData('T', '-'),
  MorseData('U', '..-'),
  MorseData('V', '...-'),
  MorseData('W', '.--'),
  MorseData('X', '-..-'),
  MorseData('Y', '-.--'),
  MorseData('Z', '--..'),
];

// Data Angka 0-9
final List<MorseData> numberMorse = [
  MorseData('1', '.----'),
  MorseData('2', '..---'),
  MorseData('3', '...--'),
  MorseData('4', '....-'),
  MorseData('5', '.....'),
  MorseData('6', '-....'),
  MorseData('7', '--...'),
  MorseData('8', '---..'),
  MorseData('9', '----.'),
  MorseData('0', '-----'),
];

// --- 1. TITLE WIDGET ---
class LibraryTitle extends StatelessWidget {
  const LibraryTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Kamus Sandi\nMorse',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF005A9C),
            height: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Klik huruf atau angka dan\ndengarkan suaranya',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

// --- 2. CUSTOM TOGGLE SWITCH ---
class CustomToggle extends StatelessWidget {
  final bool isAlphabet;
  final ValueChanged<bool> onChanged;

  const CustomToggle({
    Key? key,
    required this.isAlphabet,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Stack(
        children: [
          // Background Kuning yang bergeser
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            alignment: isAlphabet
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: Container(
              width: 140,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFFFD500),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
          // Teks Label
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(true),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Text(
                      'Alfabet (A-Z)',
                      style: TextStyle(
                        fontWeight: isAlphabet
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isAlphabet
                            ? Colors.black87
                            : Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(false),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Text(
                      'Angka (0-9)',
                      style: TextStyle(
                        fontWeight: !isAlphabet
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: !isAlphabet
                            ? Colors.black87
                            : Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// --- 3. MORSE GRID & CARD ---
class MorseCard extends StatelessWidget {
  final MorseData data;
  final VoidCallback onTap;

  const MorseCard({Key? key, required this.data, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
        ), // Tambahkan padding sedikit
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              data.char,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF005A9C),
              ),
            ),
            const SizedBox(width: 12),

            // --- BAGIAN INI YANG DIUPDATE ---
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: _buildMorseSymbols(data.code),
              ),
            ),

            // -------------------------------
          ],
        ),
      ),
    );
  }

  // Fungsi untuk mengubah string ".-" menjadi widget UI (titik kuning, garis merah)
  Widget _buildMorseSymbols(String code) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: code.split('').map((char) {
        if (char == '.') {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: const Color(0xFFFFD500), width: 2),
            ),
          );
        } else if (char == '-') {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            width: 16,
            height: 6,
            decoration: BoxDecoration(
              color: const Color(0xFFE53935), // Merah untuk dash
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }
        return const SizedBox();
      }).toList(),
    );
  }
}
