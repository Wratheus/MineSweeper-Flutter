import 'package:flutter/material.dart';
import 'package:minesweeper/src/core/models/difficulty.dart';
import 'package:minesweeper/src/feature/game/provider/provider.dart';
import 'package:minesweeper/src/feature/game/widgets/screen.dart';
import 'package:provider/provider.dart';

class MineSweeperGamePlayMain extends StatelessWidget {
  const MineSweeperGamePlayMain({required this.difficulty, super.key});

  final Difficulty difficulty;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (_) => GameProvider()..newGame(difficulty),
    child: const MinesweeperGameplayScreen(),
  );
}
