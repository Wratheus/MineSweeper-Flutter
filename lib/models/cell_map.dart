import 'dart:ui';

import 'package:minesweeper/src/core/cell.dart';
import 'package:minesweeper/src/core/coord.dart';
import 'package:minesweeper/src/core/matrix.dart';

class FlagMap {
  FlagMap({required this.size}) : flagMap = Matrix(Cell.closed, size: size) {
    _countOfClosedCells = size.width.toInt() * size.height.toInt();
    _countOfFlaggedCells = 0;
  }

  final Matrix flagMap;
  final Size size;

  int _countOfClosedCells = 0;
  int _countOfFlaggedCells = 0;

  Cell? get(Coord coord) => flagMap.getCell(coord);

  void setOpenedToCell(Coord coord) {
    flagMap.setCell(coord, Cell.opened);
    _countOfClosedCells--;
  }

  void setFlaggedToCell(Coord coord) {
    final current = flagMap.getCell(coord);
    if (current == Cell.flagged) {
      flagMap.setCell(coord, Cell.closed);
      _countOfFlaggedCells--;
    } else if (current == Cell.closed) {
      flagMap.setCell(coord, Cell.flagged);
      _countOfFlaggedCells++;
    }
  }

  void setBombedToCell(Coord coord) {
    flagMap.setCell(coord, Cell.bombed);
  }

  void setNoBombToFlaggedCell(Coord coord) {
    if (flagMap.getCell(coord) == Cell.flagged) {
      flagMap.setCell(coord, Cell.nobomb);
    }
  }

  void setOpenedToClosedBombCell(Coord coord) {
    if (flagMap.getCell(coord) == Cell.closed) {
      flagMap.setCell(coord, Cell.opened);
    }
  }

  int getCountOfClosedCells() => _countOfClosedCells;

  int getTotalFlags() => _countOfFlaggedCells;

  int getCountOfFlaggedCellsAround(Coord coord) {
    int count = 0;
    for (final around in coord.getCoordsAround(size)) {
      if (flagMap.getCell(around) == Cell.flagged) {
        count++;
      }
    }
    return count;
  }
}
