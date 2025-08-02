import 'package:flutter/material.dart';
import 'package:minesweeper/src/core/models/atoms/coord.dart';
import 'package:minesweeper/src/core/models/atoms/difficulty.dart';
import 'package:minesweeper/src/core/models/game.dart';

class MinesweeperGameplayScreen extends StatefulWidget {
  const MinesweeperGameplayScreen({super.key});

  @override
  State<MinesweeperGameplayScreen> createState() =>
      _MinesweeperGameplayScreenState();
}

class _MinesweeperGameplayScreenState extends State<MinesweeperGameplayScreen> {
  final Game game = Game(difficulty: Difficulty.beginner);

  @override
  Widget build(BuildContext context) {
    final int cols = game.difficulty.size.width;
    final int rows = game.difficulty.size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minesweeper'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Text('State: ${game.getState()}'),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols,
              ),
              itemCount: rows * cols,
              itemBuilder: (context, index) {
                final int x = index % cols;
                final int y = index ~/ cols;
                final coord = Coord(x, y);

                final cell = game.getCell(coord);

                return GestureDetector(
                  onTap: () => pressedLeftButton(coord),
                  onLongPress: () => pressedRightButton(coord),
                  child: Image(image: cell.image),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void pressedLeftButton(Coord coord) => setState(
    () => game
      ..openCell(coord)
      ..checkWin(),
  );

  void pressedRightButton(Coord coord) {
    setState(() {
      if (game.state == GameState.playing) {
        game.flag.setFlaggedToCell(coord);
        game.checkWin();
      }
    });
  }
}
