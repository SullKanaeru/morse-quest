import 'package:flutter/material.dart';
import 'package:morsequest/shared/models/user_model.dart';

class ResultHeader extends StatelessWidget {
  final int totalStars;
  final int maxStars;

  const ResultHeader({
    Key? key,
    required this.totalStars,
    required this.maxStars,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Text(
            '🏆 Selesai!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF005A9C),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              maxStars,
              (index) => Icon(
                index < totalStars ? Icons.star : Icons.star_border,
                color: index < totalStars
                    ? const Color(0xFFFFD500)
                    : Colors.grey.shade300,
                size: 32,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$totalStars dari $maxStars bintang',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class ResultStats extends StatelessWidget {
  final int totalStars;
  final int maxStars;
  final int pointsEarned;
  final bool isPerfect;

  const ResultStats({
    Key? key,
    required this.totalStars,
    required this.maxStars,
    required this.pointsEarned,
    required this.isPerfect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isPerfect ? Colors.green.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isPerfect ? Colors.green : Colors.grey.shade200,
          width: isPerfect ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          if (isPerfect) ...[
            const Icon(Icons.emoji_events, color: Color(0xFFFFD500), size: 48),
            const SizedBox(height: 8),
            const Text(
              'SEMPURNA! ⭐⭐⭐',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFD500),
              ),
            ),
            const SizedBox(height: 12),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStat(
                icon: Icons.star,
                label: 'Bintang',
                value: '$totalStars/$maxStars',
                color: const Color(0xFFFFD500),
              ),
              _buildStat(
                icon: Icons.monetization_on,
                label: 'Point',
                value: '+$pointsEarned',
                color: Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class QuestionResultItem extends StatelessWidget {
  final int questionNumber;
  final QuestionResult result;

  const QuestionResultItem({
    Key? key,
    required this.questionNumber,
    required this.result,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: result.isCorrect ? Colors.green.shade200 : Colors.red.shade200,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: result.isCorrect ? Colors.green : Colors.red,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$questionNumber',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              result.isCorrect ? '✅ Benar' : '❌ Salah',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: result.isCorrect ? Colors.green : Colors.red,
              ),
            ),
          ),
          if (result.isCorrect) ...[
            Row(
              children: List.generate(
                result.stars,
                (index) =>
                    const Icon(Icons.star, color: Color(0xFFFFD500), size: 18),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${result.timeUsed}s',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}

class ResultButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;

  const ResultButton({
    Key? key,
    required this.text,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        elevation: 2,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
