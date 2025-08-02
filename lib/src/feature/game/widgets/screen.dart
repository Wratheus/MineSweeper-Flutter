import 'package:flutter/material.dart';
import 'package:minesweeper/src/core/models/cell.dart';
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
  late Game game;
  Difficulty selectedDifficulty = Difficulty.beginner;

  @override
  void initState() {
    super.initState();
    game = Game(difficulty: selectedDifficulty);
  }

  void _startNewGame() {
    setState(() {
      game = Game(difficulty: selectedDifficulty);
    });
  }

  void _onLeftClick(Coord coord) {
    if (game.getState() == GameState.playing ||
        game.getState() == GameState.start) {
      setState(() => game.openCell(coord));
    }
  }

  void _onRightClick(Coord coord) {
    if (game.getState() == GameState.playing) {
      setState(() => game.flag.toggleFlag(coord));
    }
  }

  @override
  Widget build(BuildContext context) {
    final int cols = game.difficulty.size.width;
    final int rows = game.difficulty.size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minesweeper'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: DropdownButton<Difficulty>(
              value: selectedDifficulty,
              underline: Container(),
              dropdownColor: Colors.blue,
              iconEnabledColor: Colors.white,
              items: Difficulty.values
                  .map(
                    (d) => DropdownMenuItem<Difficulty>(
                      value: d,
                      child: Text(
                        '${d.name[0].toUpperCase()}${d.name.substring(1)} (${d.size.width}x${d.size.height}, mines: ${d.mines})',
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (difficulty) {
                if (difficulty != null) {
                  setState(() {
                    selectedDifficulty = difficulty;
                    _startNewGame();
                  });
                }
              },
            ),
          ),
          IconButton(icon: const Icon(Icons.refresh), onPressed: _startNewGame),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              game.getState().name.toUpperCase(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _getStateColor(game.getState()),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Text('Flags: ${_countFlags()} / ${game.difficulty.mines}'),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Размер доступного пространства
                final double maxWidth = constraints.maxWidth - 16; // с padding
                final maxHeight = constraints.maxHeight - 16;

                // Размер ячейки по ширине и высоте
                final double cellWidth = maxWidth / cols;
                final double cellHeight = maxHeight / rows;

                // Выбираем минимальный размер, чтобы сетка умещалась по обеим осям
                final cellSize = cellWidth < cellHeight
                    ? cellWidth
                    : cellHeight;

                // Ограничение по минимальному и максимальному размеру ячейки
                final double clampedCellSize = cellSize.clamp(16.0, 40.0);

                return GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cols,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                  ),
                  itemCount: rows * cols,
                  itemBuilder: (context, index) {
                    final int x = index % cols;
                    final int y = index ~/ cols;
                    final Coord coord = Coord(x, y);
                    final Cell cell = game.getCell(coord);

                    return GestureDetector(
                      onTap: () => _onLeftClick(coord),
                      onLongPress: () => _onRightClick(coord),
                      onSecondaryTap: () => _onRightClick(coord),
                      child: Container(
                        width: clampedCellSize,
                        height: clampedCellSize,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          color: _getCellBackgroundColor(cell),
                        ),
                        child: Image.asset(cell.imagePath, fit: BoxFit.contain),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getStateColor(GameState state) {
    switch (state) {
      case GameState.win:
        return Colors.green;
      case GameState.lose:
        return Colors.red;
      case GameState.playing:
        return Colors.orange;
      case GameState.start:
        return Colors.black87;
    }
  }

  Color _getCellBackgroundColor(Cell cell) {
    switch (cell) {
      case Cell.opened:
        return Colors.grey.shade200;
      case Cell.flagged:
        return Colors.yellow.shade200;
      case Cell.bombed:
        return Colors.red.shade300;
      default:
        return Colors.grey.shade300;
    }
  }

  int _countFlags() {
    int count = 0;
    for (int x = 0; x < game.difficulty.size.width; x++) {
      for (int y = 0; y < game.difficulty.size.height; y++) {
        final Coord coord = Coord(x, y);
        if (game.flag.get(coord) == Cell.flagged) {
          count++;
        }
      }
    }
    return count;
  }
}
