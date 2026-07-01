import 'package:flutter/material.dart';
import '../services/audio_service.dart';

class SoundProvider extends ChangeNotifier {
  final AudioService _audioService = AudioService();

  bool _isSoundOn = true;
  bool _isInitialized = false;

  bool get isSoundOn => _isSoundOn;

  SoundProvider() {
    _loadSettings();
  }

  void _loadSettings() {
    _isSoundOn = true;
  }

  void toggleSound() {
    _isSoundOn = !_isSoundOn;
    _audioService.toggleSound();
    notifyListeners();
    _saveSettings();
  }

  void setSoundOn(bool value) {
    _isSoundOn = value;
    _audioService.setSoundOn(_isSoundOn);
    notifyListeners();
    _saveSettings();
  }

  void playBackgroundMusic() {
    if (!_isInitialized) {
      _isInitialized = true;
      _audioService.playBackgroundMusic();
    } else {
      _audioService.resumeBackgroundMusic();
    }
  }

  void stopBackgroundMusic() {
    _audioService.stopBackgroundMusic();
  }

  void pauseBackgroundMusic() {
    _audioService.pauseBackgroundMusic();
  }

  void resumeBackgroundMusic() {
    _audioService.resumeBackgroundMusic();
  }

  void playDot() {
    _audioService.playDot();
  }

  void playDash() {
    _audioService.playDash();
  }

  void playSpace() {
    _audioService.playSpace();
  }

  Future<void> playMorseSequence(String morseCode) async {
    _audioService.stopMorse();
    await Future.delayed(const Duration(milliseconds: 100));
    await _audioService.playMorseSequence(morseCode);
  }

  void stopMorse() {
    _audioService.stopMorse();
  }

  void playCorrect() {
    _audioService.playUiSound('correct');
  }

  void playWrong() {
    _audioService.playUiSound('wrong');
  }

  void playLevelComplete() {
    _audioService.playUiSound('level_complete');
  }

  void playCorrectForShop() {
    _audioService.playUiSoundForShop('correct');
  }

  void playWrongForShop() {
    _audioService.playUiSoundForShop('wrong');
  }

  void _saveSettings() {}

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }
}
