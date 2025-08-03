import 'package:flutter/material.dart';
import 'package:minesweeper/src/core/models/cell.dart';
import 'package:minesweeper/src/core/models/coord.dart';
import 'package:minesweeper/src/core/models/difficulty.dart';
import 'package:minesweeper/src/core/models/game.dart';
import 'package:minesweeper/src/feature/game/provider.dart';
import 'package:minesweeper/src/feature/game/widgets/confetti.dart';
import 'package:minesweeper/src/feature/game/widgets/status_item.dart';
import 'package:provider/provider.dart';

class MinesweeperGameplayScreen extends StatelessWidget {
  const MinesweeperGameplayScreen({super.key});

  @override
  Widget build(BuildContext context) => Consumer<GameProvider>(
    builder: (context, controller, _) {
      final game = controller.game;
      final cols = game.difficulty.size.width;
      final rows = game.difficulty.size.height;

      return Scaffold(
        appBar: AppBar(
          actions: [
            _buildDifficultySelector(controller),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => controller.newGame(game.difficulty),
            ),
          ],
        ),
        body: CustomConfettiWidget(
          game: game,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StatusItem(
                        icon: Icons.flag,
                        text: '${game.countFlags} / ${game.difficulty.mines}',
                      ),
                      StatusItem(
                        icon: Icons.timer,
                        text: '${controller.secondsElapsed}s',
                      ),
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
                    physics: const NeverScrollableScrollPhysics(),
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
                        onTap: () => controller.onLeftClick(coord),
                        onLongPress: () => controller.onRightClick(coord),
                        onSecondaryTap: () => controller.onRightClick(coord),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          decoration: BoxDecoration(
                            color: _getCellBackgroundColor(cell),
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(1.5),
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
              ],
            ),
          ),
        ),
      );
    },
  );

  Widget _buildDifficultySelector(GameProvider controller) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: DropdownButton<Difficulty>(
      value: controller.game.difficulty,
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
        if (difficulty != null && difficulty != controller.game.difficulty) {
          controller.newGame(difficulty);
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
