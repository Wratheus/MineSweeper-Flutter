import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:minesweeper/src/core/models/cell.dart';
import 'package:minesweeper/src/core/models/coord.dart';
import 'package:minesweeper/src/core/models/difficulty.dart';
import 'package:minesweeper/src/core/models/game.dart';

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

  void onLeftClick(Coord coord) {
    if (_game.state == GameState.start || _game.state == GameState.playing) {
      if (_game.state == GameState.start) {
        _stopwatch.start();
      }
      _game.openCell(coord);
      if (_game.state == GameState.lose) {
        _stopwatch.stop();
        _animateLose(coord);
        return;
      }
      if (_game.state == GameState.win) {
        _stopwatch.stop();
      }
      notifyListeners();
    }
  }

  Future<void> _animateLose(Coord bombClicked) async {
    // Собираем список всех мин
    final mines = <Coord>[];
    for (int x = 0; x < _game.difficulty.size.width; x++) {
      for (int y = 0; y < _game.difficulty.size.height; y++) {
        final coord = Coord(x, y);
        if (_game.bomb.cellByCoord(coord) == Cell.bomb) {
          mines.add(coord);
        }
      }
    }

    // Сначала взорванная мина
    _game.flag.detonateBomb(bombClicked);
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 250));

    // Потом остальные
    for (final coord in mines.where((c) => c != bombClicked)) {
      _game.flag.revealBomb(coord);
      notifyListeners();
      await Future<void>.delayed(const Duration(milliseconds: 100));
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

  void onRightClick(Coord coord) {
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
