import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:minesweeper/src/core/models/cell.dart';
import 'package:minesweeper/src/core/models/coord.dart';
import 'package:minesweeper/src/core/models/difficulty.dart';
import 'package:minesweeper/src/core/models/game.dart';
import 'package:minesweeper/src/feature/app/provider/provider.dart';
import 'package:provider/provider.dart';

class GameProvider extends ChangeNotifier {
  GameProvider({this.difficulty = Difficulty.beginner}) {
    _game = Game(difficulty: difficulty);
    _ticker = Ticker(_onTick)..start();
  }

  late Game _game;
  final Difficulty difficulty;
  int _secondsElapsed = 0;
  final Stopwatch _stopwatch = Stopwatch();
  late final Ticker _ticker;

  /// Идентификатор текущей сессии игры to protect future _animateLose
  int _sessionId = 0;

  void _onTick(Duration _) {
    if (_stopwatch.isRunning) {
      _secondsElapsed = _stopwatch.elapsed.inSeconds;
      notifyListeners();
    }
  }

  void onLeftClick(BuildContext context, Coord coord) {
    if (_game.state == GameState.start || _game.state == GameState.playing) {
      if (_game.state == GameState.start) {
        _stopwatch.start();
      }
      _game.openCell(
        coord,
        onOpenCellCallback: () =>
            context.read<AppProvider>().soundManager.playDig(),
      );
      if (_game.state == GameState.lose) {
        _stopwatch.stop();
        _animateLose(context, coord);
        return;
      }
      if (_game.state == GameState.win) {
        context.read<AppProvider>().soundManager.playWin();
        _stopwatch.stop();
      }
      notifyListeners();
    }
  }

  Future<void> _animateLose(BuildContext context, Coord mineClicked) async {
    final int currentSession = _sessionId;

    final mines = <Coord>[];
    final mistakes = <Coord>[];

    for (int x = 0; x < _game.difficulty.size.width; x++) {
      for (int y = 0; y < _game.difficulty.size.height; y++) {
        // Проверка если игра уже была перезапущена ничего не делать
        // Пользователь не дождался анимации
        if (currentSession != _sessionId) return;

        final coord = Coord(x, y);
        final isMine = _game.mine.cellByCoord(coord) == Cell.mine;
        final isFlagged = _game.flag.get(coord) == Cell.flagged;

        if (isMine) {
          mines.add(coord);
        } else if (isFlagged) {
          mistakes.add(coord);
        }
      }
    }

    Coord mineToDetonate;
    if (_game.mine.cellByCoord(mineClicked) == Cell.mine) {
      // Если реально кликнули по мине
      mineToDetonate = mineClicked;
    } else {
      // Если кликнули по числу, ищем ближайшую незафлагованную мину
      final unflaggedMines =
          mines.where((m) => _game.flag.get(m) != Cell.flagged).toList()
            ..sort((a, b) {
              final da =
                  (a.x - mineClicked.x).abs() +
                  (a.y - mineClicked.y).abs(); // Манхэттен
              final db =
                  (b.x - mineClicked.x).abs() + (b.y - mineClicked.y).abs();
              return da.compareTo(db);
            });

      mineToDetonate = unflaggedMines.first;
    }

    // Помечаем ошибочные флаги
    for (final coord in mistakes) {
      if (currentSession != _sessionId) return;
      _game.flag.markNoMine(coord);
      notifyListeners();
    }

    final int explosionDelayMs = switch (_game.difficulty) {
      Difficulty.beginner => 230,
      Difficulty.intermediate => 215,
      Difficulty.expert => 200,
      Difficulty.deadEnd => 100,
      Difficulty() => 150,
    };

    // Детонируем выбранную мину
    _game.flag.detonateMine(mineToDetonate);
    notifyListeners();
    context.read<AppProvider>().soundManager.playExplosion();
    await Future<void>.delayed(Duration(milliseconds: explosionDelayMs));

    final groupedMines = <int, List<Coord>>{};

    for (final mine in mines.where((c) => c != mineToDetonate)) {
      final distance =
          (mine.x - mineToDetonate.x).abs() + (mine.y - mineToDetonate.y).abs();
      groupedMines.putIfAbsent(distance, () => []).add(mine);
    }

    // Сортируем по ключам (расстояние) для взрывной волны
    final sortedDistances = groupedMines.keys.toList()..sort();

    for (final distance in sortedDistances) {
      for (final coord in groupedMines[distance]!) {
        if (currentSession != _sessionId) return;
        _game.flag.revealMine(coord);
      }
      notifyListeners();
      if (context.mounted) {
        context.read<AppProvider>().soundManager.playExplosion();
      }
      await Future<void>.delayed(Duration(milliseconds: explosionDelayMs));
    }
  }

  void newGame(Difficulty difficulty) {
    _sessionId++; // Увеличиваем ID игры
    _game = Game(difficulty: difficulty);
    _stopwatch
      ..reset()
      ..stop();
    _secondsElapsed = 0;
    notifyListeners();
  }

  void onRightClick(BuildContext context, Coord coord) {
    context.read<AppProvider>().soundManager.playFlag();
    if (_game.state == GameState.playing) {
      _game.flag.toggleFlag(coord);
      notifyListeners();
    }
  }

  Game get game => _game;

  int get secondsElapsed => _secondsElapsed;

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
}
