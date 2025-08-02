import 'package:flutter/material.dart';
import 'package:minesweeper/src/core/models/coord.dart';
import 'package:minesweeper/src/core/models/difficulty.dart';
import 'package:minesweeper/src/core/models/game.dart';

class MinesweeperGameplayScreen extends StatefulWidget {
  const MinesweeperGameplayScreen({super.key});

  @override
  State<MinesweeperGameplayScreen> createState() =>
      _MinesweeperGameplayScreenState();
}

class _MinesweeperGameplayScreenState extends State<MinesweeperGameplayScreen> {
  Game game = Game(difficulty: Difficulty.beginner);

  @override
  Widget build(BuildContext context) {
    final int cols = game.difficulty.size.width;
    final int rows = game.difficulty.size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minesweeper'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _onNewGamePress,
          ),
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
                  onTap: () => _onMouseLeft(coord),
                  onSecondaryTap: () => _onMouseRight(coord),
                  onLongPress: () => _onMouseRight(coord),
                  child: Image(image: AssetImage(cell.imagePath)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onNewGamePress() =>
      setState(() => game = Game(difficulty: Difficulty.beginner));

  void _onMouseLeft(Coord coord) => setState(
    () => game
      ..openCell(coord)
      ..checkWin(),
  );

  void _onMouseRight(Coord coord) {
    setState(() {
      if (game.state == GameState.playing) {
        game.flag.toggleFlag(coord);
        game.checkWin();
      }
    });
  }
}
