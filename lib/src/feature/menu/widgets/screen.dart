import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:minesweeper/src/core/models/difficulty.dart';
import 'package:minesweeper/src/core/utils/window.dart';
import 'package:minesweeper/src/feature/app/provider/provider.dart';
import 'package:minesweeper/src/feature/game/main.dart';
import 'package:minesweeper/src/feature/menu/widgets/card.dart';
import 'package:minesweeper/src/feature/menu/widgets/custom_dialog.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  Future<void> _startGame(BuildContext context, Difficulty difficulty) async {
    if (!kIsWeb) {
      await WindowUtils.updateWindowSize(difficulty);
    }
    if (!context.mounted) return;
    await Navigator.push(
      context,
      PageRouteBuilder<Object?>(
        pageBuilder: (_, _, _) =>
            MineSweeperGamePlayMain(difficulty: difficulty),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final tween = Tween(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeInOut));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  void _showCustomDifficultyDialog(BuildContext context) {
    showDialog<Object?>(
      context: context,
      builder: (_) => CustomDifficultyDialog(
        onStart: (difficulty) => _startGame(context, difficulty),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.primary.withValues(alpha: 0.8),
              colorScheme.secondary.withValues(alpha: 0.8),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverList.list(
              children: [
                SafeArea(child: _buildAppBar(context)),
                const SizedBox(height: 50),
                Icon(Icons.grid_3x3, size: 80, color: colorScheme.onPrimary),
                const SizedBox(height: 16),
                Text(
                  'minesweeper',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                SafeArea(
                  top: false,
                  minimum: const EdgeInsets.only(bottom: kToolbarHeight),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DifficultyCard(
                          difficulty: Difficulty.beginner,
                          title: '😄 Beginner',
                          subtitle:
                              'Easy start\n${Difficulty.beginner.size}, ${Difficulty.beginner.mines} mines',
                          onTap: () => _startGame(context, Difficulty.beginner),
                        ),
                        const SizedBox(height: 15),
                        DifficultyCard(
                          difficulty: Difficulty.intermediate,
                          title: '🥸 Intermediate',
                          subtitle:
                              'For experienced\n${Difficulty.intermediate.size}, ${Difficulty.intermediate.mines} mines',
                          onTap: () =>
                              _startGame(context, Difficulty.intermediate),
                        ),
                        const SizedBox(height: 15),
                        DifficultyCard(
                          difficulty: Difficulty.expert,
                          title: '💀 Expert',
                          subtitle:
                              'Only for the brave\n${Difficulty.expert.size}, ${Difficulty.expert.mines} mines',
                          onTap: () => _startGame(context, Difficulty.expert),
                        ),
                        const SizedBox(height: 15),
                        DifficultyCard(
                          difficulty: Difficulty.deadEnd,
                          title: '☠️ Dead-end',
                          subtitle:
                              'Impossible..\n${Difficulty.deadEnd.size}, ${Difficulty.deadEnd.mines} mines',
                          onTap: () => _startGame(context, Difficulty.deadEnd),
                        ),
                        const SizedBox(height: 15),
                        DifficultyCard(
                          difficulty: null,
                          title: '🎨 Custom',
                          subtitle: 'Set your own size and mines',
                          onTap: () => _showCustomDifficultyDialog(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: Icon(
              context.watch<AppProvider>().soundOn
                  ? Icons.volume_up
                  : Icons.volume_off,
              color: colorScheme.onPrimary,
            ),
            onPressed: () => context.read<AppProvider>().toggleSound(),
          ),
          IconButton(
            icon: Icon(
              context.read<AppProvider>().isDark
                  ? Icons.light_mode
                  : Icons.dark_mode,
              color: colorScheme.onPrimary,
            ),
            onPressed: () => context.read<AppProvider>().toggleTheme(),
          ),
        ],
      ),
    );
  }
}
