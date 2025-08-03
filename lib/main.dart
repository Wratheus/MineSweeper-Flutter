import 'dart:io';

import 'package:flutter/material.dart';
import 'package:minesweeper/src/feature/app/main.dart';
import 'package:window_size/window_size.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('minesweeper');
    setWindowMinSize(const Size(300, 400));
    setWindowMaxSize(Size.infinite);
  }

  runApp(const AppMain());
}
