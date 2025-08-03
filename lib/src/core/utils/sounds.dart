import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

enum AppMusic { menu, game, none }

class SoundManager {
  factory SoundManager() => _instance;

  SoundManager._internal();

  static final SoundManager _instance = SoundManager._internal();

  final AudioPlayer _backgroundPlayer = AudioPlayer();
  final AudioPlayer _effectPlayer = AudioPlayer();

  bool _isSoundOn = true;

  void setSoundOn({required bool value}) {
    _isSoundOn = value;
    if (!value) {
      stopBackground();
      _effectPlayer.stop();
    }
  }

  bool get isSoundOn => _isSoundOn;

  Future<void> play(AppMusic music) async => switch (music) {
    AppMusic.menu => await playBackground('sounds/menu.mp3'),
    AppMusic.game => await playBackground('sounds/background.mp3'),
    AppMusic.none => await stopBackground(),
  };

  Future<void> playBackground(String assetPath) async {
    if (!_isSoundOn) return;
    await Future<void>.delayed(const Duration(seconds: 1));
    await _backgroundPlayer.play(AssetSource(assetPath));
  }

  Future<void> stopBackground() async =>
      Future<void>.microtask(() async => _backgroundPlayer.stop());

  Future<void> playEffect(String assetPath) async {
    if (!_isSoundOn) return;
    await _effectPlayer.stop();
    await _effectPlayer.setReleaseMode(ReleaseMode.stop);
    await _effectPlayer.play(AssetSource(assetPath));
  }

  Future<void> playDig() async => playEffect('sounds/dig.ogg');

  Future<void> playFlag(BuildContext context) async =>
      playEffect('sounds/flag.mp3');

  Future<void> playExplosion(BuildContext context) async {
    final sounds = [
      'sounds/explosion1.ogg',
      'sounds/explosion2.ogg',
      'sounds/explosion3.ogg',
    ];
    await playEffect(sounds[1]);
  }

  Future<void> playWin(BuildContext context) async {
    await playEffect('sounds/win.wav');
  }
}
