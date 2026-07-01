import 'constants.dart';

class ScoringSystem {
  static int calculateStars(int timeUsed, int timeLimit) {
    if (timeUsed > timeLimit) return 0;

    double ratio = timeUsed / timeLimit;

    if (ratio <= AppConstants.starThreshold1) return 3;
    if (ratio <= AppConstants.starThreshold2) return 2;
    if (ratio <= AppConstants.starThreshold3) return 1;
    return 0;
  }

  static int calculatePoints(int stars, int timeUsed) {
    if (stars == 0) return 0;

    int basePoints = stars * 20;
    int timeBonus = ((60 - timeUsed).clamp(0, 30) ~/ 5) * 5;
    return basePoints + timeBonus;
  }

  static bool shouldGetHint(int totalStars) {
    return totalStars > 0 && totalStars % AppConstants.starsPerHint == 0;
  }

  static String textToMorse(String text) {
    const morseMap = {
      'A': '.-',
      'B': '-...',
      'C': '-.-.',
      'D': '-..',
      'E': '.',
      'F': '..-.',
      'G': '--.',
      'H': '....',
      'I': '..',
      'J': '.---',
      'K': '-.-',
      'L': '.-..',
      'M': '--',
      'N': '-.',
      'O': '---',
      'P': '.--.',
      'Q': '--.-',
      'R': '.-.',
      'S': '...',
      'T': '-',
      'U': '..-',
      'V': '...-',
      'W': '.--',
      'X': '-..-',
      'Y': '-.--',
      'Z': '--..',
      '1': '.----',
      '2': '..---',
      '3': '...--',
      '4': '....-',
      '5': '.....',
      '6': '-....',
      '7': '--...',
      '8': '---..',
      '9': '----.',
      '0': '-----',
      ' ': '/',
    };

    return text
        .toUpperCase()
        .split('')
        .map((char) {
          return morseMap[char] ?? char;
        })
        .join(' ');
  }
}
