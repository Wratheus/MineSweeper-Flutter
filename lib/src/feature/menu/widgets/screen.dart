import 'package:flutter/material.dart';
import 'package:minesweeper/src/core/models/difficulty.dart';
import 'package:minesweeper/src/feature/app/provider/provider.dart';
import 'package:minesweeper/src/feature/game/provider/provider.dart';
import 'package:minesweeper/src/feature/game/widgets/screen.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  void _startGame(BuildContext context, Difficulty difficulty) {
    _updateWindowSize(difficulty);
    Navigator.push(
      context,
      PageRouteBuilder<Object?>(
        pageBuilder: (_, _, _) => ChangeNotifierProvider(
          create: (_) => GameProvider()..newGame(difficulty),
          child: const MinesweeperGameplayScreen(),
        ),
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

  Future<void> _updateWindowSize(Difficulty difficulty) async {
    final double cellSize = switch(difficulty) {
      Difficulty.beginner => 50,
      Difficulty.intermediate => 40,
      Difficulty.expert => 30,
    };

    const double horizontalPadding = 32;
    const double appBarHeight = 56; // Стандартная высота AppBar
    const double verticalPadding = 120 + appBarHeight;

    const double spacing = 1;

    final double totalSpacingWidth = difficulty.size.width * spacing;
    final double totalSpacingHeight = difficulty.size.height * spacing;

    final double width =
        difficulty.size.width * cellSize +
        horizontalPadding +
        totalSpacingWidth;
    final double height =
        difficulty.size.height * cellSize +
        verticalPadding +
        totalSpacingHeight;

    final Screen? screen = await getCurrentScreen();
    if (screen == null) return;

    setWindowFrame(
      Rect.fromLTWH(
        (screen.frame.width - width) / 2,
        (screen.frame.height - height) / 2,
        width,
        height,
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
                        _buildDifficultyCard(
                          context,
                          Difficulty.beginner,
                          '😄 Beginner',
                          'Easy start',
                        ),
                        const SizedBox(height: 15),
                        _buildDifficultyCard(
                          context,
                          Difficulty.intermediate,
                          '🥸 Intermediate',
                          'For experienced',
                        ),
                        const SizedBox(height: 15),
                        _buildDifficultyCard(
                          context,
                          Difficulty.expert,
                          '💀 Expert',
                          'Only for the brave',
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

  Widget _buildDifficultyCard(
    BuildContext context,
    Difficulty difficulty,
    String title,
    String subtitle,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () => _startGame(context, difficulty),
      child: Card(
        color: colorScheme.surface.withValues(alpha: 0.95),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 20,
            children: [
              Text(title, style: theme.textTheme.titleLarge),
              Flexible(
                child: Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
