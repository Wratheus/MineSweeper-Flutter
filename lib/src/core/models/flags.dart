import 'package:minesweeper/src/core/models/atoms/cell.dart';
import 'package:minesweeper/src/core/models/atoms/coord.dart';
import 'package:minesweeper/src/core/models/atoms/matrix.dart';
import 'package:minesweeper/src/core/models/size.dart';

class Flags {
  Flags({required this.size}) : map = Matrix(Cell.closed, size: size) {
    _countOfClosedCells = size.squareSize;
    _countOfFlaggedCells = 0;
  }

  final Matrix map;
  final BoardSize size;

  int _countOfClosedCells = 0;
  int _countOfFlaggedCells = 0;

  Cell? get(Coord coord) => map.getCell(coord);

  void setOpenedToCell(Coord coord) {
    map.setCell(coord, Cell.opened);
    _countOfClosedCells--;
  }

  void setFlaggedToCell(Coord coord) {
    final current = map.getCell(coord);
    if (current == Cell.flagged) {
      map.setCell(coord, Cell.closed);
      _countOfFlaggedCells--;
    } else if (current == Cell.closed) {
      map.setCell(coord, Cell.flagged);
      _countOfFlaggedCells++;
    }
  }

  void setBombedToCell(Coord coord) {
    map.setCell(coord, Cell.bombed);
  }

  void setNoBombToFlaggedCell(Coord coord) {
    if (map.getCell(coord) == Cell.flagged) {
      map.setCell(coord, Cell.nobomb);
    }
  }

  void setOpenedToClosedBombCell(Coord coord) {
    if (map.getCell(coord) == Cell.closed) {
      map.setCell(coord, Cell.opened);
    }
  }

  int getCountOfClosedCells() => _countOfClosedCells;

  int getTotalFlags() => _countOfFlaggedCells;

  int getCountOfFlaggedCellsAround(Coord coord) {
    int count = 0;
    coord.forEachNeighbor(size, (around) {
      if (map.getCell(around) == Cell.flagged) {
        count++;
      }
    });
    return count;
  }
}
