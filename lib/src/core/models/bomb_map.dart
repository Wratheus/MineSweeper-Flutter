import 'dart:math';
import 'dart:ui';

import 'package:minesweeper/src/core/models/atoms/cell.dart';
import 'package:minesweeper/src/core/models/atoms/coord.dart';
import 'package:minesweeper/src/core/models/atoms/matrix.dart';

class BombMap {
  BombMap({required this.bombsCount, required Size size})
    : map = Matrix(Cell.zero, size: size) {
    _placeBombs();
  }

  final Matrix map;
  final int bombsCount;

  final Random _random = Random();

  Cell? cellByCoord(Coord coord) => map.getCell(coord);

  void _placeBombs() {
    int i = 0;
    while (i < bombsCount) {
      final bomb = _getRandomCoord();
      if (cellByCoord(bomb) != Cell.bomb) {
        map.setCell(bomb, Cell.bomb);
        _placeNumbersAroundBomb(bomb);
        i++;
      }
    }
  }

  Coord _getRandomCoord() =>
      Coord(_random.nextInt(map.width), _random.nextInt(map.height));

  void _placeNumbersAroundBomb(Coord bomb) {
    for (final Coord around in bomb.getCoordsAround(map.size)) {
      if (cellByCoord(around) != Cell.bomb) {
        map.setCell(around, cellByCoord(around)!.getNextNum());
      }
    }
  }
}
