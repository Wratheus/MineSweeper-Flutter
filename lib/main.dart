import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:minesweeper/src/feature/app/main.dart';
import 'package:window_size/window_size.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    // Веб-версия
    runWebApp();
  } else {
    // Десктопная версия
    await runDesktopApp();
  }
}

void runWebApp() {
  runApp(const AppMain());
}

Future<void> runDesktopApp() async {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    setWindowTitle('minesweeper');
    setWindowMinSize(const Size(300, 400));
    setWindowMaxSize(Size.infinite);
    final screen = await getCurrentScreen();
    if (screen == null) return;

    const windowWidth = 600.0;
    const windowHeight = 800.0;

    final left = (screen.frame.width - windowWidth) / 2;
    final top = (screen.frame.height - windowHeight) / 2;

    setWindowFrame(Rect.fromLTWH(left, top, windowWidth, windowHeight));
  }

  runApp(const AppMain());
}
