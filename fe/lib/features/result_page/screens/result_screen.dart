import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:morsequest/features/result_page/widgets/result_widgets.dart';
import 'package:morsequest/features/main_page/screens/main_screen.dart';
import 'package:morsequest/shared/models/user_model.dart';
import 'package:morsequest/shared/utils/scoring.dart';
import 'package:morsequest/shared/providers/sound_provider.dart';

class ResultScreen extends StatelessWidget {
  final String levelId;
  final List<QuestionResult> results;
  final int totalStars;
  final int pointsEarned;

  const ResultScreen({
    super.key,
    required this.levelId,
    required this.results,
    required this.totalStars,
    required this.pointsEarned,
  });

  @override
  Widget build(BuildContext context) {
    final soundProvider = Provider.of<SoundProvider>(context);
    final bool isPerfect = totalStars == 3;
    final bool gotHint = ScoringSystem.shouldGetHint(totalStars);

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      body: SafeArea(
        child: Column(
          children: [
            ResultHeader(totalStars: totalStars, maxStars: 3),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    ResultStats(
                      totalStars: totalStars,
                      maxStars: 3,
                      pointsEarned: pointsEarned,
                      isPerfect: isPerfect,
                    ),
                    const SizedBox(height: 24),
                    ...results.asMap().entries.map((entry) {
                      final index = entry.key;
                      final result = entry.value;
                      return QuestionResultItem(
                        questionNumber: index + 1,
                        result: result,
                      );
                    }),
                    const SizedBox(height: 24),
                    if (gotHint)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD500).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFFFD500),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.lightbulb,
                              color: Color(0xFFFFD500),
                              size: 24,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                '🎉 Selamat! Kamu dapat 1 HINT GRATIS dari 25 bintang!',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: ResultButton(
                            text: 'ULANGI',
                            icon: Icons.replay,
                            backgroundColor: Colors.grey.shade200,
                            textColor: Colors.black87,
                            onPressed: () {
                              soundProvider.resumeBackgroundMusic();
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ResultButton(
                            text: 'KEMBALI',
                            icon: Icons.home,
                            backgroundColor: const Color(0xFFFFD500),
                            textColor: Colors.black87,
                            onPressed: () {
                              soundProvider.resumeBackgroundMusic();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const MainScreen(),
                                ),
                                (route) => false,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
