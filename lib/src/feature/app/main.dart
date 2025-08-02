import 'package:flutter/material.dart';
import 'package:minesweeper/src/feature/game/main.dart';

class AppMain extends StatelessWidget {
  const AppMain({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Minesweeper',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorSchemeSeed: Colors.blue,
      brightness: Brightness.light,
    ),
    home: const MineSweeperGamePlayMain(),
  );
}
