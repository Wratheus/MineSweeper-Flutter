import 'dart:collection';

import 'package:minesweeper/src/core/models/atoms/cell.dart';
import 'package:minesweeper/src/core/models/atoms/coord.dart';
import 'package:minesweeper/src/core/models/atoms/difficulty.dart';
import 'package:minesweeper/src/core/models/bomb_map.dart';
import 'package:minesweeper/src/core/models/cell_map.dart';

enum GameState { start, playing, lose, win }

class Game {
  Game({required this.difficulty})
    : bomb = BombMap(bombsCount: difficulty.mines, size: difficulty.size),
      flag = FlagMap(size: difficulty.size);

  final BombMap bomb;
  final FlagMap flag;
  final Difficulty difficulty;
  GameState state = GameState.start;

  final Set<Coord> _checkedCells = HashSet();

  Cell getCell(Coord coord) {
    final Cell? cellByCoord = flag.get(coord);
    if (cellByCoord == null) {
      throw Exception('cellByCoord == null');
    }

    if (cellByCoord == Cell.opened) {
      return bomb.cellByCoord(coord)!;
    } else {
      return flag.get(coord)!;
    }
  }

  void _revealAround(Coord coord) {
    for (final Coord around in coord.getCoordsAround(difficulty.size)) {
      if (!_checkedCells.contains(around)) {
        _checkedCells.add(coord);
        switch (flag.get(around)) {
          case Cell.flagged:
            break;
          case Cell.closed:
            switch (bomb.cellByCoord(around)) {
              case Cell.bomb:
                break;
              case Cell.zero:
                flag.setOpenedToCell(around);
                _revealAround(around);
              default:
                flag.setOpenedToCell(around);
            }
          default:
            break;
        }
      }
    }
  }

  void openCell(Coord coord) {
    switch (state) {
      case GameState.start:
        if (bomb.cellByCoord(coord) != Cell.bomb) {
          flag.setOpenedToCell(coord);
        }
        _revealAround(coord);
        state = GameState.playing;
      case GameState.playing:
        if (flag.get(coord) == Cell.opened) {
          _setOpenedToClosedBombCellsAround(coord);
        }
        if (flag.get(coord) == Cell.closed) {
          switch (bomb.cellByCoord(coord)) {
            case Cell.bomb:
              lose(coord);
            case Cell.zero:
              flag.setOpenedToCell(coord);
              _revealAround(coord);
            default:
              flag.setOpenedToCell(coord);
          }
        }
      default:
        break;
    }
  }

  void _setOpenedToClosedBombCellsAround(Coord coord) {
    if (bomb.cellByCoord(coord) != Cell.bomb) {
      if (flag.getCountOfFlaggedCellsAround(coord) ==
          bomb.cellByCoord(coord)!.number) {
        for (final around in coord.getCoordsAround(difficulty.size)) {
          if (flag.get(around) == Cell.closed) {
            openCell(around);
          }
        }
      }
    }
  }

  void lose(Coord bombClicked) {
    state = GameState.lose;
    for (final coord in Coord(
      difficulty.size.width,
      difficulty.size.height,
    ).getCoordsAround(difficulty.size)) {
      if (bomb.cellByCoord(coord) == Cell.bomb) {
        flag.setOpenedToClosedBombCell(coord);
      } else {
        flag.setNoBombToFlaggedCell(coord);
      }
    }
    flag.setBombedToCell(bombClicked);
  }

  void checkWin() {
    if (state == GameState.playing) {
      if (flag.getCountOfClosedCells() == bomb.bombsCount) {
        state = GameState.win;
      }
    }
  }

  GameState getState() => state;
}
