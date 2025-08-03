import 'package:flutter/cupertino.dart';

class AppProvider extends ChangeNotifier {
  bool _isDark = false;
  bool _soundOn = true;

  bool get isDark => _isDark;
  bool get soundOn => _soundOn;

  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }

  void toggleSound() {
    _soundOn = !_soundOn;
    notifyListeners();
  }
}
