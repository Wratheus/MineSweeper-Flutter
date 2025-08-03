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
      SoundManager().playDig();
      _game.openCell(coord);
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
    // Собираем список всех мин
    await SoundManager().playExplosion(context);
    final mines = <Coord>[];
    for (int x = 0; x < _game.difficulty.size.width; x++) {
      for (int y = 0; y < _game.difficulty.size.height; y++) {
        final coord = Coord(x, y);
        if (_game.mine.cellByCoord(coord) == Cell.mine) {
          mines.add(coord);
        }
      }
    }

    // Сначала взорванная мина
    _game.flag.detonateMine(mineClicked);
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 250));

    // Потом остальные
    for (final coord in mines.where((c) => c != mineClicked)) {
      _game.flag.revealMine(coord);
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
