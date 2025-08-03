import 'package:flutter/material.dart';
import 'package:minesweeper/src/core/models/cell.dart';
import 'package:minesweeper/src/core/models/coord.dart';
import 'package:minesweeper/src/core/models/game.dart';
import 'package:minesweeper/src/feature/app/provider/provider.dart';
import 'package:minesweeper/src/feature/game/provider/provider.dart';
import 'package:minesweeper/src/feature/game/widgets/confetti.dart';
import 'package:minesweeper/src/feature/game/widgets/shaker.dart';
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
            IconButton(
              icon: Icon(
                context.watch<AppProvider>().soundOn
                    ? Icons.volume_up
                    : Icons.volume_off,
              ),
              onPressed: () => context.read<AppProvider>().toggleSound(),
            ),
            IconButton(
              icon: Icon(
                context.read<AppProvider>().isDark
                    ? Icons.light_mode
                    : Icons.dark_mode,
              ),
              onPressed: () => context.read<AppProvider>().toggleTheme(),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => controller.newGame(game.difficulty),
              ),
            ),
          ],
        ),
        body: Shaker(
          animate: controller.game.state == GameState.lose,
          child: Confetti(
            game: game,
            child: Padding(
              padding: const EdgeInsets.all(8),
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
                          color: _getStateColor(context, game.state),
                        ),
                      ],
                    ),
                  ),
                  ColoredBox(
                    color: context.read<AppProvider>().isDark
                        ? Colors.white30
                        : Colors.transparent,
                    child: GridView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
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
                          onTap: () => controller.onLeftClick(context, coord),
                          onLongPress: () =>
                              controller.onRightClick(context, coord),
                          onSecondaryTap: () =>
                              controller.onRightClick(context, coord),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            decoration: BoxDecoration(
                              color: _getCellBackgroundColor(context, cell),
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
        ),
      );
    },
  );

  Color _getStateColor(BuildContext context, GameState state) =>
      switch (state) {
        GameState.win => Colors.green,
        GameState.lose => Colors.red,
        GameState.playing => Colors.orange,
        GameState.start => IconTheme.of(context).color!,
      };

  Color? _getCellBackgroundColor(BuildContext context, Cell cell) =>
      switch (cell) {
        Cell.exploded => Colors.red.shade300,
        _ => null,
      };
}
