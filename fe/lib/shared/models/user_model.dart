class UserModel {
  final String id;
  final String username;
  final String email;
  final int points;
  final int hints;
  final int totalStars;
  final Map<String, LevelProgress> levelProgress;
  final bool isSoundOn;

  final String avatarUrl;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.avatarUrl = 'assets/images/hanif.jpeg',
    this.points = 0,
    this.hints = 0,
    this.totalStars = 0,
    this.levelProgress = const {},
    this.isSoundOn = true,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['avatar_url'] ?? 'assets/images/hanif.jpeg',
      points: json['total_sp'] ?? json['points'] ?? 0,
      hints: json['hints'] ?? 0,
      totalStars: json['totalStars'] ?? 0,
      isSoundOn: json['isSoundOn'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'avatar_url': avatarUrl,
      'points': points,
      'hints': hints,
      'totalStars': totalStars,
      'isSoundOn': isSoundOn,
    };
  }

  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    String? avatarUrl,
    int? points,
    int? hints,
    int? totalStars,
    Map<String, LevelProgress>? levelProgress,
    bool? isSoundOn,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      points: points ?? this.points,
      hints: hints ?? this.hints,
      totalStars: totalStars ?? this.totalStars,
      levelProgress: levelProgress ?? this.levelProgress,
      isSoundOn: isSoundOn ?? this.isSoundOn,
    );
  }
}

class LevelProgress {
  final String levelId;
  final List<QuestionResult> results;
  final int totalStars;
  final int totalPoints;
  final DateTime lastPlayed;

  LevelProgress({
    required this.levelId,
    this.results = const [],
    this.totalStars = 0,
    this.totalPoints = 0,
    required this.lastPlayed,
  });

  factory LevelProgress.fromJson(Map<String, dynamic> json) {
    return LevelProgress(
      levelId: json['levelId'] ?? '',
      results:
          (json['results'] as List?)
              ?.map((e) => QuestionResult.fromJson(e))
              .toList() ??
          [],
      totalStars: json['totalStars'] ?? 0,
      totalPoints: json['totalPoints'] ?? 0,
      lastPlayed: DateTime.parse(
        json['lastPlayed'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'levelId': levelId,
      'results': results.map((e) => e.toJson()).toList(),
      'totalStars': totalStars,
      'totalPoints': totalPoints,
      'lastPlayed': lastPlayed.toIso8601String(),
    };
  }
}

class QuestionResult {
  final String questionId;
  final bool isCorrect;
  final int stars;
  final int timeUsed;
  final int pointsEarned;

  QuestionResult({
    required this.questionId,
    required this.isCorrect,
    required this.stars,
    required this.timeUsed,
    required this.pointsEarned,
  });

  factory QuestionResult.fromJson(Map<String, dynamic> json) {
    return QuestionResult(
      questionId: json['questionId'] ?? '',
      isCorrect: json['isCorrect'] ?? false,
      stars: json['stars'] ?? 0,
      timeUsed: json['timeUsed'] ?? 0,
      pointsEarned: json['pointsEarned'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'isCorrect': isCorrect,
      'stars': stars,
      'timeUsed': timeUsed,
      'pointsEarned': pointsEarned,
    };
  }
}
