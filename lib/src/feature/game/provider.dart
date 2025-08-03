import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
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

  void newGame(Difficulty difficulty) {
    _game = Game(difficulty: difficulty);
    _stopwatch
      ..reset()
      ..stop();
    _secondsElapsed = 0;
    notifyListeners();
  }

  void onLeftClick(Coord coord) {
    if (_game.state == GameState.start || _game.state == GameState.playing) {
      if (_game.state == GameState.start) {
        _stopwatch.start();
      }
      _game.openCell(coord);
      if (_game.state == GameState.win || _game.state == GameState.lose) {
        _stopwatch.stop();
      }
      notifyListeners();
    }
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
