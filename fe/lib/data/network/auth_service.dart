import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:morsequest/core/config/api_config.dart';

class AuthService {
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse(ApiConfig.login);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final token = response.headers['authorization']?.replaceFirst('Bearer ', '');
      final data = jsonDecode(response.body);
      return {
        'success': true,
        'token': token,
        'data': data,
      };
    } else {
      final error = jsonDecode(response.body);
      return {
        'success': false,
        'message': error['error'] ?? 'Gagal login',
      };
    }
  }

  static Future<Map<String, dynamic>> register(String email, String username, String password) async {
    final url = Uri.parse(ApiConfig.register);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return {
        'success': true,
        'data': data,
      };
    } else {
      final error = jsonDecode(response.body);
      return {
        'success': false,
        'message': error['error'] ?? 'Gagal registrasi',
      };
    }
  }
}
