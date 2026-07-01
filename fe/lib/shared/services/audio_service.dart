import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _bgPlayer = AudioPlayer();
  final AudioPlayer _effectPlayer = AudioPlayer();

  bool _isSoundOn = true;
  double _volume = 0.5;
  bool _isBgPlaying = false;
  bool _isMorsePlaying = false;

  bool get isSoundOn => _isSoundOn;

  void toggleSound() {
    _isSoundOn = !_isSoundOn;
    if (_isSoundOn) {
      if (_isBgPlaying) {
        _bgPlayer.resume();
      } else {
        playBackgroundMusic();
      }
    } else {
      _bgPlayer.pause();
    }
  }

  void setSoundOn(bool value) {
    _isSoundOn = value;
    if (_isSoundOn) {
      if (_isBgPlaying) {
        _bgPlayer.resume();
      } else {
        playBackgroundMusic();
      }
    } else {
      _bgPlayer.pause();
    }
  }

  void setVolume(double volume) {
    _volume = volume.clamp(0.0, 1.0);
    _bgPlayer.setVolume(_volume);
    _effectPlayer.setVolume(_volume);
  }

  Future<void> playBackgroundMusic() async {
    if (!_isSoundOn) return;
    try {
      _isBgPlaying = true;
      await _bgPlayer.setReleaseMode(ReleaseMode.loop);
      await _bgPlayer.play(AssetSource('sounds/background/bg_music.mp3'));
      await _bgPlayer.setVolume(_volume);
    } catch (e) {
      _isBgPlaying = false;
      debugPrint('Error playing background music: $e');
    }
  }

  void stopBackgroundMusic() {
    _isBgPlaying = false;
    _bgPlayer.stop();
  }

  void pauseBackgroundMusic() {
    _isBgPlaying = false;
    _bgPlayer.pause();
  }

  void resumeBackgroundMusic() {
    if (_isSoundOn) {
      _isBgPlaying = true;
      _bgPlayer.resume();
    }
  }

  Future<void> playDot() async {
    if (!_isSoundOn) return;
    try {
      await _effectPlayer.stop();
      final player = AudioPlayer();
      await player.play(AssetSource('sounds/morse/dot.mp3'));
      await Future.delayed(const Duration(milliseconds: 200));
      await player.dispose();
    } catch (e) {
      debugPrint('Error playing dot: $e');
    }
  }

  Future<void> playDash() async {
    if (!_isSoundOn) return;
    try {
      await _effectPlayer.stop();
      final player = AudioPlayer();
      await player.play(AssetSource('sounds/morse/dash.mp3'));
      await Future.delayed(const Duration(milliseconds: 400));
      await player.dispose();
    } catch (e) {
      debugPrint('Error playing dash: $e');
    }
  }

  Future<void> playSpace() async {
    if (!_isSoundOn) return;
    try {
      await _effectPlayer.stop();
      await Future.delayed(const Duration(milliseconds: 250));
    } catch (e) {
      debugPrint('Error playing space: $e');
    }
  }

  Future<void> playMorseSequence(String morseCode) async {
    if (!_isSoundOn || morseCode.isEmpty) {
      debugPrint('Sound is off or morse code is empty');
      return;
    }

    debugPrint('Playing morse sequence: $morseCode');

    _isMorsePlaying = false;
    await _effectPlayer.stop();
    await Future.delayed(const Duration(milliseconds: 100));

    try {
      _isMorsePlaying = true;
      List<String> chars = morseCode.split('');

      for (int i = 0; i < chars.length; i++) {
        if (!_isMorsePlaying) {
          debugPrint('Morse sequence cancelled');
          break;
        }

        String char = chars[i];
        debugPrint('Playing char: $char');

        if (char == '.') {
          await playDot();
        } else if (char == '-') {
          await playDash();
        } else if (char == ' ') {
          await playSpace();
        }

        if (i < chars.length - 1) {
          await Future.delayed(const Duration(milliseconds: 150));
        }
      }

      _isMorsePlaying = false;
      debugPrint('Finished playing morse sequence');
    } catch (e) {
      _isMorsePlaying = false;
      debugPrint('Error playing morse sequence: $e');
    }
  }

  void stopMorse() {
    _isMorsePlaying = false;
    _effectPlayer.stop();
    debugPrint('Morse sequence stopped');
  }

  Future<void> playUiSound(String soundName) async {
    if (!_isSoundOn) return;
    try {
      final player = AudioPlayer();
      await player.play(AssetSource('sounds/ui/$soundName.mp3'));
      await Future.delayed(const Duration(milliseconds: 1000));
      await player.dispose();
    } catch (e) {
      debugPrint('Error playing UI sound: $e');
    }
  }

  Future<void> playUiSoundForShop(String soundName) async {
    if (!_isSoundOn) return;
    try {
      final player = AudioPlayer();
      await player.play(AssetSource('sounds/ui/$soundName.mp3'));
      await Future.delayed(const Duration(milliseconds: 1000));
      await player.dispose();

      if (_isSoundOn) {
        final bgStatus = await _bgPlayer.getCurrentPosition();
        if (bgStatus == null) {
          _isBgPlaying = false;
          playBackgroundMusic();
        } else {
          _bgPlayer.resume();
        }
      }
    } catch (e) {
      debugPrint('Error playing UI sound for shop: $e');
    }
  }

  void dispose() {
    _bgPlayer.dispose();
    _effectPlayer.dispose();
  }
}
