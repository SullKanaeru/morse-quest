class AppConstants {
  static const List<LevelData> levels = [
    LevelData(
      id: 'Gampang',
      title: 'Gampang',
      description: 'Praktekkan huruf dasar',
      starCount: 1,
      timeLimit: 30,
    ),
    LevelData(
      id: 'Sedang',
      title: 'Sedang',
      description: 'Pelajari kata-kata umum',
      starCount: 2,
      timeLimit: 45,
    ),
    LevelData(
      id: 'Sulit',
      title: 'Sulit',
      description: 'Kosa kata yang lebih rumit',
      starCount: 3,
      timeLimit: 60,
    ),
  ];

  static const int hintPrice1 = 300;
  static const int hintPrice3 = 600;
  static const int hintPrice5 = 1000;
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
  final int timeLimit;

  const LevelData({
    required this.id,
    required this.title,
    required this.description,
    required this.starCount,
    required this.timeLimit,
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
