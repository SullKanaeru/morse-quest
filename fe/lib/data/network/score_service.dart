import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:morsequest/core/config/api_config.dart';
import 'package:morsequest/data/storage/token_storage.dart';

class ScoreService {
  static Future<bool> submitScore({
    required String difficulty,
    required int signalPoints,
    required int streak,
    required int wordsCleared,
  }) async {
    final token = await TokenStorage.getToken();
    if (token == null) return false;

    try {
      final response = await http.post(
        Uri.parse(ApiConfig.score),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'difficulty': difficulty,
          'signal_points': signalPoints,
          'streak': streak,
          'words_cleared': wordsCleared,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
