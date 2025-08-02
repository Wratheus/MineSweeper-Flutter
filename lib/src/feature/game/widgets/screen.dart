import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:minesweeper/src/core/models/cell.dart';
import 'package:minesweeper/src/core/models/coord.dart';
import 'package:minesweeper/src/core/models/difficulty.dart';
import 'package:minesweeper/src/core/models/game.dart';
import 'package:minesweeper/src/feature/game/widgets/status_item.dart';

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
    if (game.state == GameState.playing || game.state == GameState.start) {
      if (game.state == GameState.start) {
        stopwatch
          ..reset()
          ..start();
      }
      setState(() {
        game.openCell(coord);
        if (game.state == GameState.win || game.state == GameState.lose) {
          stopwatch.stop();
        }
      });
    }
  }

  void _onRightClick(Coord coord) {
    if (game.state == GameState.playing) {
      setState(() => game.flag.toggleFlag(coord));
    }
  }

  @override
  Widget build(BuildContext context) {
    final int cols = game.difficulty.size.width;
    final int rows = game.difficulty.size.height;

    return Scaffold(
      appBar: AppBar(
        actions: [
          _buildDifficultySelector(),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _startNewGame,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StatusItem(
                    icon: Icons.flag,
                    text: '${game.countFlags} / ${game.difficulty.mines}',
                  ),
                  StatusItem(icon: Icons.timer, text: '${secondsElapsed}s'),
                  StatusItem(
                    icon: Icons.info,
                    text: game.state.name.toUpperCase(),
                    color: _getStateColor(game.state),
                  ),
                ],
              ),
            ),
            Flexible(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols,
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 1,
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
                      decoration: BoxDecoration(
                        color: _getCellBackgroundColor(cell),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(1.5),
                        child: Image.asset(cell.imagePath, fit: BoxFit.contain),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultySelector() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: DropdownButton<Difficulty>(
      value: selectedDifficulty,
      underline: const SizedBox.shrink(),
      padding: const EdgeInsets.all(5),
      borderRadius: BorderRadius.circular(5),
      items: Difficulty.values
          .map(
            (d) => DropdownMenuItem<Difficulty>(
              value: d,
              child: Row(
                children: [
                  Text(switch (d) {
                    Difficulty.beginner => '😄',
                    Difficulty.intermediate => '🥸',
                    Difficulty.expert => '💀',
                  }),
                  Text(
                    ' ${d.name[0].toUpperCase()}${d.name.substring(1)} (${d.size.width}x${d.size.height})',
                  ),
                ],
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
}
