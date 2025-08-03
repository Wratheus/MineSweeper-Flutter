import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:minesweeper/src/core/models/cell.dart';
import 'package:minesweeper/src/core/models/coord.dart';
import 'package:minesweeper/src/core/models/difficulty.dart';
import 'package:minesweeper/src/core/models/game.dart';
import 'package:minesweeper/src/core/utils/sounds.dart';

class GameProvider extends ChangeNotifier {
  GameProvider({Difficulty difficulty = Difficulty.beginner}) {
    _game = Game(difficulty: difficulty);
    _ticker = Ticker(_onTick)..start();
  }

  late Game _game;
  int _secondsElapsed = 0;
  final Stopwatch _stopwatch = Stopwatch();
  late final Ticker _ticker;

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
      _game.openCell(coord, onOpenCellCallback: () => SoundManager().playDig());
      if (_game.state == GameState.lose) {
        _stopwatch.stop();
        _animateLose(context, coord);
        return;
      }
      if (_game.state == GameState.win) {
        SoundManager().playWin(context);
        _stopwatch.stop();
      }
      notifyListeners();
    }
  }

  Future<void> _animateLose(BuildContext context, Coord mineClicked) async {
    final mines = <Coord>[];
    final mistakes = <Coord>[];

    for (int x = 0; x < _game.difficulty.size.width; x++) {
      for (int y = 0; y < _game.difficulty.size.height; y++) {
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

    // Детонируем выбранную мину
    _game.flag.detonateMine(mineToDetonate);
    notifyListeners();
    SoundManager().playExplosion();
    await Future<void>.delayed(const Duration(milliseconds: 250));

    // Показываем остальные мины
    for (final coord in mines.where((c) => c != mineToDetonate)) {
      _game.flag.revealMine(coord);
      SoundManager().playExplosion();

      notifyListeners();
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }

    // Помечаем ошибочные флаги
    for (final coord in mistakes) {
      _game.flag.markNoMine(coord);
      notifyListeners();
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }
  }

  void newGame(Difficulty difficulty) {
    _game = Game(difficulty: difficulty);
    _stopwatch
      ..reset()
      ..stop();
    _secondsElapsed = 0;
    notifyListeners();
  }

  void onRightClick(BuildContext context, Coord coord) {
    SoundManager().playFlag(context);
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
