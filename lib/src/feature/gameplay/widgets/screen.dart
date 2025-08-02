import 'package:flutter/material.dart';
import 'package:minesweeper/src/core/models/atoms/coord.dart';
import 'package:minesweeper/src/core/models/atoms/difficulty.dart';
import 'package:minesweeper/src/core/models/game.dart';
import 'package:minesweeper/src/core/models/game_state.dart';

class MinesweeperGameplayScreen extends StatefulWidget {
  const MinesweeperGameplayScreen({super.key});

  @override
  State<MinesweeperGameplayScreen> createState() =>
      _MinesweeperGameplayScreenState();
}

class _MinesweeperGameplayScreenState extends State<MinesweeperGameplayScreen> {
  final Game game = Game(difficulty: Difficulty.beginner)..start();

  @override
  Widget build(BuildContext context) {
    final int cols = game.difficulty.size.width.toInt();
    final int rows = game.difficulty.size.height.toInt();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minesweeper'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                // Сделать рестарт игры
                // Например, создать новую игру, либо вызвать reset
                // Пока просто сбросим состояние игры
                game.gamePlay.setState(GameState.start);
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Text('State: ${game.gamePlay.getState()}'),
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

                final cell = game.gamePlay.getCell(coord);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      game.gamePlay.openCell(coord);
                      game.gamePlay.checkWin();
                    });
                  },
                  onLongPress: () {
                    setState(() {
                      if (game.gamePlay.getState() == GameState.playing) {
                        game.gamePlay.getField().flag.setFlaggedToCell(coord);
                      }
                      game.gamePlay.checkWin();
                    });
                  },
                  child: Image(image: cell.image),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
