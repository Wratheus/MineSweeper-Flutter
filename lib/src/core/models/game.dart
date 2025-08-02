import 'package:minesweeper/src/core/models/atoms/coord.dart';
import 'package:minesweeper/src/core/models/atoms/difficulty.dart';
import 'package:minesweeper/src/core/models/game_field.dart';
import 'package:minesweeper/src/core/models/game_play.dart';
import 'package:minesweeper/src/core/models/game_state.dart';

class Game {
  Game({required this.difficulty})
    : gamePlay = GamePlay(field: GameField(difficulty: difficulty));

  final Difficulty difficulty;
  final GamePlay gamePlay;

  GamePlay getGamePlay() => gamePlay;

  void start() {
    gamePlay.setState(GameState.start);
  }

  void pressedLeftButton(Coord coord) {
    gamePlay
      ..openCell(coord)
      ..checkWin();
  }

  void pressedRightButton(Coord coord) {
    if (gamePlay.getState() == GameState.playing) {
      gamePlay.field.flag.setFlaggedToCell(coord);
      gamePlay.checkWin();
    }
  }
}
