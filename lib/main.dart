import 'package:flutter/material.dart';
import 'package:minesweeper/game.dart';
import 'package:minesweeper/models/game.dart';
import 'package:minesweeper/models/game_play.dart';
import 'package:minesweeper/src/core/difficulty.dart';

void main() {
  final Game game = Game(difficulty: Difficulty.beginner)..start();

  runApp(MyApp(gamePlay: game.gamePlay));
}

class MyApp extends StatelessWidget {
  const MyApp({required this.gamePlay, super.key});

  final GamePlay gamePlay;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Minesweeper',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    ),
    home: MinesweeperGameWidget(gamePlay: gamePlay),
  );
}
