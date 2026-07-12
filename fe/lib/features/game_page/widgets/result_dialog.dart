import 'package:flutter/material.dart';
import 'package:morsequest/shared/models/user_model.dart';

class ResultDialog extends StatelessWidget {
  final QuestionResult result;
  final VoidCallback onNext;
  final int currentQuestion;
  final int totalQuestions;

  const ResultDialog({
    super.key,
    required this.result,
    required this.onNext,
    required this.currentQuestion,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              result.isCorrect ? Icons.check_circle : Icons.cancel,
              color: result.isCorrect ? Colors.green : Colors.red,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              result.isCorrect ? 'Benar! 🎉' : 'Yah, salah! 😅',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (result.isCorrect) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  result.stars,
                  (index) => const Icon(
                    Icons.star,
                    color: Color(0xFFFFD500),
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Waktu: ${result.timeUsed}s | +${result.pointsEarned} point',
                style: const TextStyle(color: Colors.grey),
              ),
            ] else ...[
              const Text(
                'Coba lagi lain kali!',
                style: TextStyle(color: Colors.grey),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD500),
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  currentQuestion < totalQuestions ? 'LANJUT' : 'LIHAT HASIL',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
