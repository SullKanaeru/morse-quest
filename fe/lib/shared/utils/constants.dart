class AppConstants {
  static const List<LevelData> levels = [
    LevelData(
      id: 'easy',
      title: 'Gampang',
      description: 'Praktekkan huruf dasar',
      starCount: 1,
      questions: [
        Question(
          id: 'q1',
          target: 'KUCING',
          morseCode: '-.- ..- -.-. .. -. --.',
          timeLimit: 30,
        ),
        Question(
          id: 'q2',
          target: 'BURUNG',
          morseCode: '-... ..- .-. ..- -. --.',
          timeLimit: 30,
        ),
        Question(
          id: 'q3',
          target: 'IKAN',
          morseCode: '.. -.- .- -.',
          timeLimit: 30,
        ),
      ],
    ),
    LevelData(
      id: 'medium',
      title: 'Sedang',
      description: 'Pelajari kata-kata umum',
      starCount: 2,
      questions: [
        Question(
          id: 'q4',
          target: 'I LOVE U',
          morseCode: '.. / .-.. --- ...- . / ..-',
          timeLimit: 45,
        ),
        Question(
          id: 'q5',
          target: 'GOOD JOB',
          morseCode: '--. --- --- -.. / .--- --- -...',
          timeLimit: 45,
        ),
        Question(
          id: 'q6',
          target: 'HELLO',
          morseCode: '.... . .-.. .-.. ---',
          timeLimit: 45,
        ),
      ],
    ),
    LevelData(
      id: 'hard',
      title: 'Sulit',
      description: 'Kosa kata yang lebih rumit',
      starCount: 3,
      questions: [
        Question(
          id: 'q7',
          target: 'MORSE CODE',
          morseCode: '-- --- .-. ... . / -.-. --- -.. .',
          timeLimit: 60,
        ),
        Question(
          id: 'q8',
          target: 'KEEP GOING',
          morseCode: '-.- . . .--. / --. --- .. -. --.',
          timeLimit: 60,
        ),
        Question(
          id: 'q9',
          target: 'NEVER GIVE UP',
          morseCode: '-. . ...- . .-. / --. .. ...- . / ..- .--.',
          timeLimit: 75,
        ),
      ],
    ),
  ];

  static const int hintPrice4 = 10000;
  static const int hintPrice10 = 22000;
  static const int starsPerHint = 25;

  static const int maxStars = 3;
  static const double starThreshold1 = 0.3;
  static const double starThreshold2 = 0.6;
  static const double starThreshold3 = 1.0;
}

class LevelData {
  final String id;
  final String title;
  final String description;
  final int starCount;
  final List<Question> questions;

  const LevelData({
    required this.id,
    required this.title,
    required this.description,
    required this.starCount,
    required this.questions,
  });
}

class Question {
  final String id;
  final String target;
  final String morseCode;
  final int timeLimit;

  const Question({
    required this.id,
    required this.target,
    required this.morseCode,
    required this.timeLimit,
  });
}
