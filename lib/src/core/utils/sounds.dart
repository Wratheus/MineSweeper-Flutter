import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class SoundManager {
  void playEffect(String assetPath) {
    try {
      final AudioPlayer player = AudioPlayer();
      player.play(AssetSource(assetPath)).ignore();
    } on Object catch (_) {}
  }

  void playDig() => playEffect('sounds/dig.ogg');

  void playFlag(BuildContext context) => playEffect('sounds/flag.mp3');

  void playExplosion() {
    final Random random = Random();
    final sounds = [
      'sounds/explosion1.ogg',
      'sounds/explosion2.ogg',
      'sounds/explosion3.ogg',
    ];
    playEffect(sounds[random.nextInt(3)]);
  }

  void playWin(BuildContext context) => playEffect('sounds/win.wav');
}
