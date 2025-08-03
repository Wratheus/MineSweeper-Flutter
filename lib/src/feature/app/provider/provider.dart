import 'package:flutter/foundation.dart';
import 'package:minesweeper/src/core/utils/sounds.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider extends ChangeNotifier {
  final SoundManager soundManager = SoundManager();

  bool _isDark = false;
  bool _soundOn = true;
  int _record = 0;

  bool get isDark => _isDark;

  bool get soundOn => _soundOn;

  int get record => _record;

  // Загрузка настроек из SharedPreferences
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool('isDark') ?? false;
    _soundOn = prefs.getBool('soundOn') ?? true;
    _record = prefs.getInt('record') ?? 0;
    soundManager.soundOn = _soundOn;
    notifyListeners();
  }

  // Сохранение настроек
  Future<void> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', _isDark);
    await prefs.setBool('soundOn', _soundOn);
    await prefs.setInt('record', _record);
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

  void updateRecord(int newRecord) {
    if (newRecord < _record || _record == 0) {
      _record = newRecord;
      saveSettings();
      notifyListeners();
    }
  }
}
