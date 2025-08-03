import 'package:flutter/material.dart';
import 'package:minesweeper/src/core/models/difficulty.dart';
import 'package:minesweeper/src/feature/app/provider/provider.dart';
import 'package:minesweeper/src/feature/game/provider/provider.dart';
import 'package:minesweeper/src/feature/game/widgets/screen.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  void _startGame(BuildContext context, Difficulty difficulty) =>
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final record = context.watch<AppProvider>().record;

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
                  'Minesweeper',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                if (record > 0) ...[
                  const SizedBox(height: 10),
                  Text(
                    'Your best record: $record',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onPrimary.withValues(alpha: 0.85),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],

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
                          'Easy start for newcomers',
                        ),
                        const SizedBox(height: 15),
                        _buildDifficultyCard(
                          context,
                          Difficulty.intermediate,
                          '🥸 Intermediate',
                          'For experienced players',
                        ),
                        const SizedBox(height: 15),
                        _buildDifficultyCard(
                          context,
                          Difficulty.expert,
                          '💀 Expert',
                          'Only for the brave!',
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
            children: [
              Text(title, style: theme.textTheme.titleLarge),
              const Spacer(),
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
