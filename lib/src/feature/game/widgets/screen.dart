import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
  int secondsElapsed = 0;
  late final Stopwatch stopwatch;
  late final Ticker ticker;

  @override
  void initState() {
    super.initState();
    game = Game(difficulty: selectedDifficulty);
    stopwatch = Stopwatch();
    ticker = Ticker((_) {
      if (stopwatch.isRunning) {
        setState(() {
          secondsElapsed = stopwatch.elapsed.inSeconds;
        });
      }
    });
    ticker.start();
  }

  @override
  void dispose() {
    ticker.dispose();
    super.dispose();
  }

  void _startNewGame() {
    setState(() {
      game = Game(difficulty: selectedDifficulty);
      stopwatch
        ..reset()
        ..start();
      secondsElapsed = 0;
    });
  }

  void _onLeftClick(Coord coord) {
    if (game.getState() == GameState.playing ||
        game.getState() == GameState.start) {
      if (game.getState() == GameState.start) {
        stopwatch
          ..reset()
          ..start();
      }
      setState(() {
        game.openCell(coord);
        if (game.getState() == GameState.win ||
            game.getState() == GameState.lose) {
          stopwatch.stop();
        }
      });
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
        title: const Text(
          'Minesweeper',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          _buildDifficultySelector(),
          IconButton(icon: const Icon(Icons.refresh), onPressed: _startNewGame),
        ],
      ),
      body: Column(
        children: [
          _buildStatusPanel(),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double maxWidth = constraints.maxWidth - 16;
                final double cellSize = (maxWidth / cols).clamp(16.0, 40.0);

                return Center(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 8),
                      ],
                    ),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
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
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: cellSize,
                            height: cellSize,
                            decoration: BoxDecoration(
                              color: _getCellBackgroundColor(cell),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.grey.shade400),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Image.asset(
                                cell.imagePath,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPanel() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _statusItem(Icons.flag, '${_countFlags()} / ${game.difficulty.mines}'),
        _statusItem(Icons.timer, '${secondsElapsed}s'),
        _statusItem(
          Icons.info,
          game.getState().name.toUpperCase(),
          color: _getStateColor(game.getState()),
        ),
      ],
    ),
  );

  Widget _statusItem(IconData icon, String text, {Color? color}) => Row(
    children: [
      Icon(icon, color: color ?? Theme.of(context).colorScheme.primary),
      const SizedBox(width: 6),
      Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: color ?? Colors.black87,
        ),
      ),
    ],
  );

  Widget _buildDifficultySelector() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: DropdownButton<Difficulty>(
      value: selectedDifficulty,
      underline: Container(),
      items: Difficulty.values
          .map(
            (d) => DropdownMenuItem<Difficulty>(
              value: d,
              child: Text(
                '${d.name[0].toUpperCase()}${d.name.substring(1)} (${d.size.width}x${d.size.height})',
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
  );

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
