import 'package:flutter/material.dart';

// --- 1. HEADER (Bisa pakai ulang dari MainScreen, tapi kita buatkan agar mandiri) ---
class GameHeader extends StatelessWidget {
  const GameHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.school, color: Color(0xFF005A9C), size: 28),
              const SizedBox(width: 8),
              const Text(
                'MorseQuest',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF005A9C),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                const Text(
                  '120',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                const SizedBox(width: 8),
                Container(width: 1, height: 12, color: Colors.grey.shade400),
                const SizedBox(width: 8),
                const Icon(Icons.monetization_on, color: Colors.grey, size: 16),
                const SizedBox(width: 4),
                const Text(
                  '50',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- 2. BACK BUTTON ---
class GameBackButton extends StatelessWidget {
  final VoidCallback onTap;

  const GameBackButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 18,
                color: Color(0xFF005A9C),
              ),
            ),
            const SizedBox(width: 16),
            const Text(
              'Kembali',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF005A9C),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- 3. STATS ROW (TARGET & WAKTU) ---
class GameStatsRow extends StatelessWidget {
  final String targetWord;
  final String time;

  const GameStatsRow({Key? key, required this.targetWord, required this.time})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blue.shade200, width: 1.5),
              ),
              child: Column(
                children: [
                  const Text(
                    'Target',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    targetWord,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF005A9C),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.red.shade300, width: 1.5),
              ),
              child: Column(
                children: [
                  const Text(
                    'Waktu',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD32F2F),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- 4. PLAY CARD ---
class PlayCard extends StatelessWidget {
  const PlayCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 30),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.blue.shade100, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.05),
            spreadRadius: 2,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w800,
                letterSpacing: 4,
              ),
              children: [
                TextSpan(
                  text: 'K',
                  style: TextStyle(color: Colors.grey.shade300),
                ),
                const TextSpan(
                  text: 'U',
                  style: TextStyle(color: Color(0xFF005A9C)),
                ),
                TextSpan(
                  text: 'CING',
                  style: TextStyle(color: Colors.grey.shade300),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildMorseDot(isFilled: true),
                const SizedBox(width: 8),
                _buildMorseDash(isFilled: true),
                const SizedBox(width: 8),
                _buildMorseDash(isFilled: true),
                const SizedBox(width: 8),
                _buildMorseDot(isFilled: false),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Combo x3',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFC107),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMorseDot({required bool isFilled}) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isFilled ? const Color(0xFFFFD500) : Colors.transparent,
        border: Border.all(
          color: isFilled ? Colors.black87 : Colors.grey.shade400,
          width: 1.5,
        ),
      ),
    );
  }

  Widget _buildMorseDash({required bool isFilled}) {
    return Container(
      width: 32,
      height: 14,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isFilled ? const Color(0xFFFFD500) : Colors.transparent,
        border: Border.all(
          color: isFilled ? Colors.black87 : Colors.grey.shade400,
          width: 1.5,
        ),
      ),
    );
  }
}

// --- 5. INSTRUCTION BADGE ---
class InstructionBadge extends StatelessWidget {
  const InstructionBadge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.info_outline, size: 18, color: Colors.grey.shade700),
          const SizedBox(width: 8),
          Text(
            'TAP SHORT OR HOLD LONG',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}

// --- 6. TRANSMIT BUTTON ---
class TransmitButton extends StatelessWidget {
  final VoidCallback onTapDown;
  final VoidCallback onTapUp;

  const TransmitButton({
    Key? key,
    required this.onTapDown,
    required this.onTapUp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => onTapDown(),
      onTapUp: (_) => onTapUp(),
      onTapCancel: () => onTapUp(), // Handle jika jari geser ke luar tombol
      child: Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF005A9C),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF005A9C).withOpacity(0.3),
              blurRadius: 40,
              spreadRadius: 10,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Center(
          child: Container(
            width: 155,
            height: 155,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.blue.shade300.withOpacity(0.5),
                width: 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.touch_app, size: 50, color: Colors.white),
                SizedBox(height: 8),
                Text(
                  'TRANSMIT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
