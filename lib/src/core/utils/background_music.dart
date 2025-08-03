import 'package:audioplayers/audioplayers.dart';

class BackgroundMusicPlayer {
  factory BackgroundMusicPlayer() => _instance;

  BackgroundMusicPlayer._internal();

  static final BackgroundMusicPlayer _instance =
      BackgroundMusicPlayer._internal();

  final AudioPlayer _player = AudioPlayer();

  Future<void> play() async {
    try {
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.play(AssetSource('sounds/menu.mp3'), volume: 0.1);
    } on Object catch (_) {}
  }

  Future<void> stop() async {
    try {
      await _player.stop();
    } on Object catch (_) {}
  }

  Future<void> pause() async {
    try {
      await _player.pause();
    } on Object catch (_) {}
  }
}
