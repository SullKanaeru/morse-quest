import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:morsequest/core/config/api_config.dart';
import 'package:morsequest/data/storage/token_storage.dart';

class WordService {
  /// Mengambil daftar kata soal dari API berdasarkan tingkat kesulitan.
  /// Mengembalikan list of maps dengan key: id, word, morse_code, difficulty.
  static Future<Map<String, dynamic>> getWords(String difficulty) async {
    final token = await TokenStorage.getToken();
    if (token == null) {
      return {
        'success': false,
        'message': 'Token tidak ditemukan. Silakan login ulang.',
        'data': [],
      };
    }

    final url = Uri.parse('${ApiConfig.gameWords}?difficulty=$difficulty');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return {
          'success': true,
          'message': body['message'] ?? 'Berhasil',
          'data': body['data'] as List<dynamic>,
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['error'] ?? 'Gagal mengambil kata',
          'data': [],
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Koneksi gagal: $e',
        'data': [],
      };
    }
  }
}
