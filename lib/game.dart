import 'package:flutter/material.dart';

import 'package:minesweeper/models/game_play.dart';
import 'package:minesweeper/models/game_state.dart';
import 'package:minesweeper/src/core/coord.dart';

class MinesweeperGameWidget extends StatefulWidget {
  const MinesweeperGameWidget({required this.gamePlay, super.key});

  final GamePlay gamePlay;

  @override
  State<MinesweeperGameWidget> createState() => _MinesweeperGameWidgetState();
}

class _MinesweeperGameWidgetState extends State<MinesweeperGameWidget> {
  @override
  Widget build(BuildContext context) {
    final size = widget.gamePlay.getField().difficulty.size;
    final int rows = size.width.toInt();
    final int cols = size.height.toInt();

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
                widget.gamePlay.setState(GameState.start);
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Text('State: ${widget.gamePlay.getState()}'),
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

                final cell = widget.gamePlay.getCell(coord);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.gamePlay.openCell(coord);
                      widget.gamePlay.checkWin();
                    });
                  },
                  onLongPress: () {
                    setState(() {
                      if (widget.gamePlay.getState() == GameState.playing) {
                        widget.gamePlay.getField().flag.setFlaggedToCell(coord);
                      }
                      widget.gamePlay.checkWin();
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
