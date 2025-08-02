import 'dart:collection';

import 'package:minesweeper/src/core/models/atoms/cell.dart';
import 'package:minesweeper/src/core/models/atoms/coord.dart';
import 'package:minesweeper/src/core/models/game_field.dart';
import 'package:minesweeper/src/core/models/game_state.dart';

class GamePlay {
  GamePlay({required this.field}) : state = GameState.start;

  final GameField field;
  GameState state;

  // для хранения проверенных клеток
  final Set<Coord> _checkedCells = HashSet();

  GameField getField() => field;

  Cell getCell(Coord coord) {
    final Cell? cellByCoord = field.flag.get(coord);
    if (cellByCoord == null) {
      throw Exception('cellByCoord == null');
    }

    if (cellByCoord == Cell.opened) {
      return field.bomb.cellByCoord(coord)!;
    } else {
      return field.flag.get(coord)!;
    }
  }

  void _revealAround(Coord coord) {
    for (final Coord around in coord.getCoordsAround(field.difficulty.size)) {
      if (!_checkedCells.contains(around)) {
        _checkedCells.add(coord);
        switch (field.flag.get(around)) {
          case Cell.flagged:
            break;
          case Cell.closed:
            switch (field.bomb.cellByCoord(around)) {
              case Cell.bomb:
                break;
              case Cell.zero:
                field.flag.setOpenedToCell(around);
                _revealAround(around);
              default:
                field.flag.setOpenedToCell(around);
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
        if (field.bomb.cellByCoord(coord) != Cell.bomb) {
          field.flag.setOpenedToCell(coord);
        }
        _revealAround(coord);
        setState(GameState.playing);
      case GameState.playing:
        if (field.flag.get(coord) == Cell.opened) {
          _setOpenedToClosedBombCellsAround(coord);
        }
        if (field.flag.get(coord) == Cell.closed) {
          switch (field.bomb.cellByCoord(coord)) {
            case Cell.bomb:
              lose(coord);
            case Cell.zero:
              field.flag.setOpenedToCell(coord);
              _revealAround(coord);
            default:
              field.flag.setOpenedToCell(coord);
          }
        }
      default:
        break;
    }
  }

  void _setOpenedToClosedBombCellsAround(Coord coord) {
    if (field.bomb.cellByCoord(coord) != Cell.bomb) {
      if (field.flag.getCountOfFlaggedCellsAround(coord) ==
          field.bomb.cellByCoord(coord)!.number) {
        for (final around in coord.getCoordsAround(field.difficulty.size)) {
          if (field.flag.get(around) == Cell.closed) {
            openCell(around);
          }
        }
      }
    }
  }

  void lose(Coord bombClicked) {
    setState(GameState.lose);
    for (final coord in Coord(
      field.difficulty.size.width.toInt(),
      field.difficulty.size.height.toInt(),
    ).getCoordsAround(field.difficulty.size)) {
      if (field.bomb.cellByCoord(coord) == Cell.bomb) {
        field.flag.setOpenedToClosedBombCell(coord);
      } else {
        field.flag.setNoBombToFlaggedCell(coord);
      }
    }
    field.flag.setBombedToCell(bombClicked);
  }

  void checkWin() {
    if (state == GameState.playing) {
      if (field.flag.getCountOfClosedCells() == field.bomb.bombsCount) {
        setState(GameState.win);
      }
    }
  }

  GameState getState() => state;

  void setState(GameState newState) {
    state = newState;
  }
}
