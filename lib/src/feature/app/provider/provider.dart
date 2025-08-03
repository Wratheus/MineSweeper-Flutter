import 'package:flutter/foundation.dart';
import 'package:minesweeper/src/core/utils/sounds.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider extends ChangeNotifier {
  final SoundManager soundManager = SoundManager();

  bool _isDark = false;
  bool _soundOn = true;

  bool get isDark => _isDark;

  bool get soundOn => _soundOn;

  // Загрузка настроек из SharedPreferences
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool('isDark') ?? false;
    _soundOn = prefs.getBool('soundOn') ?? true;
    soundManager.soundOn = _soundOn;
    notifyListeners();
  }

  // Сохранение настроек
  Future<void> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', _isDark);
    await prefs.setBool('soundOn', _soundOn);
  }

  void toggleTheme() {
    _isDark = !_isDark;
    saveSettings();
    notifyListeners();
  }

  void toggleSound() {
    _soundOn = !_soundOn;
    soundManager.soundOn = _soundOn;
    saveSettings();
    notifyListeners();
  }
}
