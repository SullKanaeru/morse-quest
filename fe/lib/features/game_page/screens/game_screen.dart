import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:morsequest/features/game_page/widgets/game_widgets.dart';
import 'package:morsequest/features/game_page/widgets/morse_keyboard.dart';
import 'package:morsequest/features/game_page/widgets/result_dialog.dart';
import 'package:morsequest/features/result_page/screens/result_screen.dart';
import 'package:morsequest/shared/utils/constants.dart';
import 'package:morsequest/shared/utils/scoring.dart';
import 'package:morsequest/shared/models/user_model.dart';
import 'package:morsequest/shared/providers/sound_provider.dart';

class GameScreen extends StatefulWidget {
  final LevelData levelData;

  const GameScreen({Key? key, required this.levelData}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int _currentQuestionIndex = 0;
  String _morseInput = '';
  int _timerSeconds = 0;
  bool _isTimerRunning = false;
  bool _isSubmitting = false;
  List<QuestionResult> _results = [];
  late Question _currentQuestion;
  int _combo = 0;

  @override
  void initState() {
    super.initState();
    _results = [];
    _currentQuestion = widget.levelData.questions[0];
    _timerSeconds = _currentQuestion.timeLimit;
    _startTimer();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final soundProvider = Provider.of<SoundProvider>(context, listen: false);
      soundProvider.pauseBackgroundMusic();
    });
  }

  @override
  void dispose() {
    _isTimerRunning = false;
    final soundProvider = Provider.of<SoundProvider>(context, listen: false);
    soundProvider.resumeBackgroundMusic();
    super.dispose();
  }

  void _startTimer() {
    if (_isTimerRunning) return;
    _isTimerRunning = true;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() {
        if (_timerSeconds > 0) {
          _timerSeconds--;
        } else {
          _isTimerRunning = false;
          _handleTimeout();
        }
      });
      return _isTimerRunning;
    });
  }

  void _handleTimeout() {
    _submitAnswer();
  }

  void _handleMorseInput(String input) {
    setState(() {
      _morseInput = input;
    });
  }

  void _addDot() {
    if (_morseInput.length < 20) {
      _handleMorseInput(_morseInput + '.');
      final soundProvider = Provider.of<SoundProvider>(context, listen: false);
      soundProvider.playDot();
    }
  }

  void _addDash() {
    if (_morseInput.length < 20) {
      _handleMorseInput(_morseInput + '-');
      final soundProvider = Provider.of<SoundProvider>(context, listen: false);
      soundProvider.playDash();
    }
  }

  void _addSpace() {
    if (_morseInput.length < 20) {
      _handleMorseInput(_morseInput + ' ');
      final soundProvider = Provider.of<SoundProvider>(context, listen: false);
      soundProvider.playSpace();
    }
  }

  void _removeLast() {
    if (_morseInput.isNotEmpty) {
      _handleMorseInput(_morseInput.substring(0, _morseInput.length - 1));
    }
  }

  void _submitAnswer() async {
    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);

    final soundProvider = Provider.of<SoundProvider>(context, listen: false);

    _isTimerRunning = false;

    final timeUsed = _currentQuestion.timeLimit - _timerSeconds;
    final isCorrect = _morseInput.trim() == _currentQuestion.morseCode;
    final stars = isCorrect
        ? ScoringSystem.calculateStars(timeUsed, _currentQuestion.timeLimit)
        : 0;
    final pointsEarned = isCorrect
        ? ScoringSystem.calculatePoints(stars, timeUsed)
        : 0;

    final result = QuestionResult(
      questionId: _currentQuestion.id,
      isCorrect: isCorrect,
      stars: stars,
      timeUsed: timeUsed,
      pointsEarned: pointsEarned,
    );

    setState(() {
      _results.add(result);
      if (isCorrect) {
        _combo++;
        soundProvider.playCorrect();
      } else {
        _combo = 0;
        soundProvider.playWrong();
      }
    });

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ResultDialog(
        result: result,
        currentQuestion: _currentQuestionIndex + 1,
        totalQuestions: widget.levelData.questions.length,
        onNext: () {
          Navigator.pop(context);
          _nextQuestion();
        },
      ),
    );

    setState(() => _isSubmitting = false);
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < widget.levelData.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _currentQuestion = widget.levelData.questions[_currentQuestionIndex];
        _morseInput = '';
        _timerSeconds = _currentQuestion.timeLimit;
        _isTimerRunning = true;
        _startTimer();
      });
    } else {
      final soundProvider = Provider.of<SoundProvider>(context, listen: false);
      soundProvider.playLevelComplete();

      final totalStars = _results.fold(0, (sum, r) => sum + r.stars);
      final totalPoints = _results.fold(0, (sum, r) => sum + r.pointsEarned);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            levelId: widget.levelData.id,
            results: _results,
            totalStars: totalStars,
            pointsEarned: totalPoints,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      body: SafeArea(
        child: Column(
          children: [
            GameHeader(points: 0, hints: 0),
            const SizedBox(height: 10),
            GameBackButton(onTap: () => Navigator.pop(context)),
            const SizedBox(height: 20),
            GameStatsRow(
              targetWord: _currentQuestion.target,
              time: _timerSeconds.toString().padLeft(2, '0'),
              currentQuestion: _currentQuestionIndex + 1,
              totalQuestions: widget.levelData.questions.length,
            ),
            const SizedBox(height: 20),
            PlayCard(
              inputText: _morseInput,
              targetWord: _currentQuestion.target,
              combo: _combo,
            ),
            const SizedBox(height: 16),
            InstructionBadge(),
            const Spacer(),
            MorseKeyboard(
              onDot: _addDot,
              onDash: _addDash,
              onSpace: _addSpace,
              onBackspace: _removeLast,
              onSubmit: _submitAnswer,
              isSubmitting: _isSubmitting,
            ),
          ],
        ),
      ),
    );
  }
}
