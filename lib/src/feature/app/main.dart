import 'package:flutter/material.dart';
import 'package:minesweeper/src/feature/game/main.dart';

class AppMain extends StatelessWidget {
  const AppMain({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Minesweeper',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    ),
    home: const MineSweeperGamePlayMain(),
  );
}
