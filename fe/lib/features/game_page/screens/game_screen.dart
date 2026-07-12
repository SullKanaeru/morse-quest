import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:morsequest/features/game_page/widgets/game_widgets.dart';
import 'package:morsequest/features/game_page/widgets/morse_keyboard.dart';
import 'package:morsequest/features/result_page/screens/result_screen.dart';
import 'package:morsequest/shared/utils/constants.dart';
import 'package:morsequest/shared/utils/scoring.dart';
import 'package:morsequest/shared/models/user_model.dart';
import 'package:morsequest/shared/providers/sound_provider.dart';
import 'package:morsequest/shared/providers/user_provider.dart';
import 'package:morsequest/data/network/word_service.dart';
import 'package:morsequest/data/network/score_service.dart';

enum GameState { loading, waiting, playing, finished }

class GameScreen extends StatefulWidget {
  final LevelData levelData;

  const GameScreen({super.key, required this.levelData});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  // Game state
  GameState _gameState = GameState.loading;
  String? _errorMessage;

  // Timer
  static const int _totalTime = 60;
  int _timerSeconds = _totalTime;
  bool _isTimerRunning = false;

  // Questions
  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  late Question _currentQuestion;
  String _morseInput = '';
  bool _isSubmitting = false;

  // Results
  List<QuestionResult> _results = [];
  int _combo = 0;
  int _correctCount = 0;
  int _wrongCount = 0;

  // Shake animation
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  // Wrong flash color
  bool _isWrongFlash = false;

  @override
  void initState() {
    super.initState();
    _results = [];

    // Shake animation controller
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 12).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
    _shakeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _shakeController.reverse();
      }
      if (status == AnimationStatus.dismissed) {
        setState(() => _isWrongFlash = false);
      }
    });

    _fetchWords();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final soundProvider = Provider.of<SoundProvider>(context, listen: false);
      soundProvider.pauseBackgroundMusic();
    });
  }

  late SoundProvider _soundProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _soundProvider = Provider.of<SoundProvider>(context, listen: false);
  }

  @override
  void dispose() {
    _isTimerRunning = false;
    _shakeController.dispose();
    _soundProvider.resumeBackgroundMusic();
    super.dispose();
  }

  // ============ FETCH WORDS ============
  Future<void> _fetchWords() async {
    setState(() {
      _gameState = GameState.loading;
      _errorMessage = null;
    });

    final result = await WordService.getWords(widget.levelData.id);

    if (!mounted) return;

    if (result['success'] && (result['data'] as List).isNotEmpty) {
      final wordsData = result['data'] as List<dynamic>;
      final questions = wordsData.map((wordMap) {
        return Question(
          id: wordMap['id'].toString(),
          target: wordMap['word'] as String,
          morseCode: wordMap['morse_code'] as String,
          timeLimit: _totalTime,
        );
      }).toList();

      setState(() {
        _questions = questions.take(5).toList();
        _currentQuestionIndex = 0;
        _currentQuestion = _questions[0];
        _gameState = GameState.waiting;
      });
    } else {
      setState(() {
        _gameState = GameState.loading;
        _errorMessage = result['message'] ?? 'Gagal mengambil soal';
      });
    }
  }

  // ============ GAME START (first tap) ============
  void _onFirstTap() {
    if (_gameState != GameState.waiting) return;
    setState(() {
      _gameState = GameState.playing;
    });
    _startTimer();
  }

  // ============ TIMER ============
  void _startTimer() {
    if (_isTimerRunning) return;
    _isTimerRunning = true;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      if (!_isTimerRunning) return false;
      setState(() {
        if (_timerSeconds > 0) {
          _timerSeconds--;
        } else {
          _isTimerRunning = false;
          _onTimeUp();
        }
      });
      return _isTimerRunning;
    });
  }

  void _onTimeUp() {
    setState(() {
      _gameState = GameState.finished;
    });

    final soundProvider = Provider.of<SoundProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    soundProvider.playLevelComplete();

    // Max 5 questions
    final int maxQuestions = 5;

    // Pad remaining questions as wrong if timer runs out before answering 5
    int remaining = maxQuestions - _results.length;
    for (int i = 0; i < remaining; i++) {
      int nextIndex = _currentQuestionIndex + i;
      if (nextIndex < _questions.length) {
        _results.add(
          QuestionResult(
            questionId: _questions[nextIndex].id,
            isCorrect: false,
            stars: 0,
            timeUsed: 0,
            pointsEarned: 0,
          ),
        );
      } else {
        _results.add(
          QuestionResult(
            questionId: 'unknown',
            isCorrect: false,
            stars: 0,
            timeUsed: 0,
            pointsEarned: 0,
          ),
        );
      }
    }

    // Total stars based on correct answers (max 3 stars)
    int totalStars = 0;
    if (_correctCount == 5) {
      totalStars = 3;
    } else if (_correctCount >= 3) {
      totalStars = 2;
    } else if (_correctCount >= 1) {
      totalStars = 1;
    }

    // Points earned logic
    // Base 50 points per correct answer, bonus 250 points for 5/5
    int totalPoints = _correctCount * 50;
    if (_correctCount == 5) {
      totalPoints += 250;
    }

    int currentStreak = 0;
    int maxStreak = 0;
    for (var r in _results) {
      if (r.isCorrect) {
        currentStreak++;
        if (currentStreak > maxStreak) maxStreak = currentStreak;
      } else {
        currentStreak = 0;
      }
    }

    // Submit ke server
    ScoreService.submitScore(
      difficulty: widget.levelData.title,
      signalPoints: totalPoints,
      streak: maxStreak,
      wordsCleared: _correctCount,
    ).then((success) {
      if (success) {
        userProvider.fetchProfile();
      }
    });

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

  // ============ MORSE INPUT ============
  void _addDot() {
    // First tap triggers game start
    if (_gameState == GameState.waiting) {
      _onFirstTap();
      return;
    }
    if (_gameState != GameState.playing) return;
    if (_morseInput.length < 30) {
      setState(() => _morseInput += '.');
      final soundProvider = Provider.of<SoundProvider>(context, listen: false);
      soundProvider.playDot();
    }
  }

  void _addDash() {
    if (_gameState == GameState.waiting) {
      _onFirstTap();
      return;
    }
    if (_gameState != GameState.playing) return;
    if (_morseInput.length < 30) {
      setState(() => _morseInput += '-');
      final soundProvider = Provider.of<SoundProvider>(context, listen: false);
      soundProvider.playDash();
    }
  }

  void _addSpace() {
    if (_gameState != GameState.playing) return;
    if (_morseInput.length < 30) {
      setState(() => _morseInput += ' ');
      final soundProvider = Provider.of<SoundProvider>(context, listen: false);
      soundProvider.playSpace();
    }
  }

  void _removeLast() {
    if (_gameState != GameState.playing) return;
    if (_morseInput.isNotEmpty) {
      setState(
        () => _morseInput = _morseInput.substring(0, _morseInput.length - 1),
      );
    }
  }

  // ============ SUBMIT ANSWER ============
  void _submitAnswer() {
    if (_gameState != GameState.playing) return;
    if (_isSubmitting || _morseInput.trim().isEmpty) return;

    setState(() => _isSubmitting = true);

    final soundProvider = Provider.of<SoundProvider>(context, listen: false);
    final isCorrect = _morseInput.trim() == _currentQuestion.morseCode;

    final timeUsed = _totalTime - _timerSeconds;
    final stars = isCorrect
        ? ScoringSystem.calculateStars(timeUsed, _totalTime)
        : 0;
    final pointsEarned = isCorrect
        ? ScoringSystem.calculatePoints(stars, timeUsed)
        : 0;

    if (isCorrect) {
      final result = QuestionResult(
        questionId: _currentQuestion.id,
        isCorrect: isCorrect,
        stars: stars,
        timeUsed: timeUsed,
        pointsEarned: pointsEarned,
      );
      _results.add(result);
      
      _combo++;
      _correctCount++;
      soundProvider.playCorrect();
      // Pindah ke kata berikutnya
      _nextWord();
    } else {
      _combo = 0;
      _wrongCount++;
      soundProvider.playWrong();
      // Shake + flash merah, tetap di kata yang sama
      _triggerWrongEffect();
    }

    setState(() => _isSubmitting = false);
  }

  void _nextWord() {
    setState(() {
      _morseInput = '';
      _currentQuestionIndex++;
      if (_currentQuestionIndex < _questions.length) {
        _currentQuestion = _questions[_currentQuestionIndex];
      } else {
        // Habis kata dari pool (max 5)
        _isTimerRunning = false;
        _onTimeUp();
      }
    });
  }

  void _triggerWrongEffect() {
    setState(() {
      _isWrongFlash = true;
      _morseInput = '';
    });
    _shakeController.forward(from: 0);
  }

  // ============ BUILD ============
  @override
  Widget build(BuildContext context) {
    // Loading state
    if (_gameState == GameState.loading && _errorMessage == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFFBFBFB),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(color: Color(0xFF005A9C)),
                const SizedBox(height: 24),
                Text(
                  'Menyiapkan soal ${widget.levelData.title}...',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF005A9C),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Error state
    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: const Color(0xFFFBFBFB),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 64),
                  const SizedBox(height: 16),
                  const Text(
                    'Gagal Memuat Soal',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Kembali'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: _fetchWords,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF005A9C),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final bool isWaiting = _gameState == GameState.waiting;

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      body: SafeArea(
        child: Column(
          children: [
            Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                final points = userProvider.user?.points ?? 0;
                final hints = userProvider.user?.hints ?? 0;
                return GameHeader(points: points, hints: hints);
              },
            ),
            const SizedBox(height: 10),
            GameBackButton(onTap: () => Navigator.pop(context)),
            const SizedBox(height: 20),

            // Stats row — show "?" when waiting
            GameStatsRow(
              targetWord: isWaiting ? '?' : _currentQuestion.target,
              time: _timerSeconds.toString().padLeft(2, '0'),
              currentQuestion: _correctCount + 1,
              totalQuestions: _questions.length,
            ),
            const SizedBox(height: 20),

            // Play card area
            if (isWaiting)
              _buildWaitingOverlay()
            else
              _buildPlayCardWithShake(),

            const SizedBox(height: 16),

            // Score bar saat bermain
            if (!isWaiting) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildScoreBadge(
                      Icons.check_circle,
                      Colors.green,
                      '$_correctCount Benar',
                    ),
                    const SizedBox(width: 16),
                    _buildScoreBadge(
                      Icons.cancel,
                      Colors.red,
                      '$_wrongCount Salah',
                    ),
                    if (_combo > 1) ...[
                      const SizedBox(width: 16),
                      _buildScoreBadge(
                        Icons.local_fire_department,
                        const Color(0xFFFFD500),
                        'Combo x$_combo',
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildHintButton(),
            ],

            const Spacer(),
            MorseKeyboard(
              onDot: _addDot,
              onDash: _addDash,
              onSpace: _addSpace,
              onBackspace: _removeLast,
              onTransmit: _submitAnswer,
              isSubmitting: _isSubmitting,
              isGlowing: isWaiting,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreBadge(IconData icon, Color color, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHintButton() {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final hints = userProvider.user?.hints ?? 0;
        return ElevatedButton.icon(
          onPressed: hints > 0 && !_isHintRunning ? _useHint : null,
          icon: const Icon(Icons.lightbulb, color: Color(0xFFFFD500)),
          label: Text('Gunakan Hint ($hints)'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            side: const BorderSide(color: Color(0xFFFFD500), width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
      },
    );
  }

  bool _isHintRunning = false;

  Future<void> _useHint() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Cegah multi-click
    if (_isHintRunning) return;
    setState(() {
      _isHintRunning = true;
    });

    final success = await userProvider.useHint();
    if (!success) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menggunakan hint.'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _isHintRunning = false;
      });
      return;
    }

    if (!mounted) return;

    // Pause game
    _isTimerRunning = false;

    // Tampilkan dialog pop-up
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.volume_up, color: Color(0xFF005A9C), size: 32),
            SizedBox(width: 8),
            Text('Dengarkan!'),
          ],
        ),
        content: const Text(
          'Sandi morse sedang diputar...',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );

    // Tunggu sedikit agar pop-up muncul dengan jelas
    await Future.delayed(const Duration(seconds: 1));

    // Putar suara
    await _soundProvider.playMorseSequence(_currentQuestion.morseCode);

    if (!mounted) return;
    // Tutup popup dialog
    Navigator.of(context).pop();

    // Lanjut main
    _isTimerRunning = false;
    _startTimer();
    setState(() {
      _isHintRunning = false;
    });
  }

  // ============ WAITING OVERLAY ============
  Widget _buildWaitingOverlay() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 40),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD500).withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              '?',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w800,
                color: Color(0xFFFFD500),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Icon(Icons.touch_app, color: Color(0xFFFFD500), size: 40),
          const SizedBox(height: 8),
          const Text(
            'Tap The Button!',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF005A9C),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tekan tombol di bawah untuk mulai',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  // ============ PLAY CARD WITH SHAKE ============
  Widget _buildPlayCardWithShake() {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            _shakeController.isAnimating
                ? sin(_shakeAnimation.value * pi * 3) * _shakeAnimation.value
                : 0,
            0,
          ),
          child: child,
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(vertical: 30),
        width: double.infinity,
        decoration: BoxDecoration(
          color: _isWrongFlash ? Colors.red.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: _isWrongFlash ? Colors.red.shade300 : Colors.blue.shade100,
            width: _isWrongFlash ? 3 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: _isWrongFlash
                  ? Colors.red.withOpacity(0.15)
                  : Colors.blue.withOpacity(0.05),
              spreadRadius: 2,
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _isWrongFlash ? Colors.red.shade50 : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _currentQuestion.target.toUpperCase(),
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 4,
                  color: _isWrongFlash ? Colors.red : const Color(0xFF005A9C),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                _morseInput.isEmpty ? 'TAP . atau —' : _morseInput,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: _morseInput.isEmpty
                      ? Colors.grey.shade400
                      : Colors.black87,
                  letterSpacing: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
