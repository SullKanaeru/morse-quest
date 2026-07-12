import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:morsequest/core/config/api_config.dart';
import 'package:morsequest/data/storage/token_storage.dart';
import 'package:morsequest/shared/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;

  Future<void> fetchProfile() async {
    final token = await TokenStorage.getToken();
    if (token == null) {
      _user = null;
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse(ApiConfig.profile),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        // The id might be parsed as int or String depending on json handling.
        // Convert to string for UserModel.
        final data = body['data'];
        data['id'] = data['id'].toString();
        _user = UserModel.fromJson(data);
      } else {
        _user = null;
        await TokenStorage.removeToken();
      }
    } catch (e) {
      // Ignored for now, user stays as is or becomes null
    }

    _isLoading = false;
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }

  Future<bool> buyHint(int amount, int cost) async {
    final token = await TokenStorage.getToken();
    if (token == null) return false;

    try {
      final response = await http.post(
        Uri.parse(ApiConfig.buyHint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'amount': amount,
          'cost': cost,
        }),
      );

      if (response.statusCode == 200) {
        await fetchProfile();
        return true;
      }
    } catch (e) {
      debugPrint("buyHint error: $e");
    }
    return false;
  }

  Future<bool> useHint() async {
    final token = await TokenStorage.getToken();
    if (token == null) return false;

    try {
      final response = await http.post(
        Uri.parse(ApiConfig.useHint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Fast local update
        if (_user != null) {
          _user = _user!.copyWith(hints: _user!.hints - 1);
          notifyListeners();
        }
        return true;
      }
    } catch (e) {
      debugPrint("useHint error: $e");
    }
    return false;
  }

  Future<bool> updateProfile(String username, String avatarUrl) async {
    final token = await TokenStorage.getToken();
    if (token == null) return false;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.put(
        Uri.parse(ApiConfig.profile),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'username': username,
          'avatar_url': avatarUrl,
        }),
      );

      if (response.statusCode == 200) {
        if (_user != null) {
          _user = _user!.copyWith(username: username, avatarUrl: avatarUrl);
        }
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint("updateProfile error: $e");
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> uploadAvatar(String imagePath) async {
    final token = await TokenStorage.getToken();
    if (token == null) return false;

    _isLoading = true;
    notifyListeners();

    try {
      var request = http.MultipartRequest('POST', Uri.parse(ApiConfig.uploadAvatar));
      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(await http.MultipartFile.fromPath('avatar', imagePath));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final avatarUrl = body['avatarUrl'];
        if (_user != null) {
          _user = _user!.copyWith(avatarUrl: avatarUrl);
        }
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint("uploadAvatar error: $e");
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }
}
