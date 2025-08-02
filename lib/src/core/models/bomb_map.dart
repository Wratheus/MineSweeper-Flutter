import 'dart:math';

import 'package:minesweeper/src/core/models/atoms/cell.dart';
import 'package:minesweeper/src/core/models/atoms/coord.dart';
import 'package:minesweeper/src/core/models/atoms/matrix.dart';
import 'package:minesweeper/src/core/models/size.dart';

class BombMap {
  BombMap({required this.bombsCount, required BoardSize size})
    : map = Matrix(Cell.zero, size: size) {
    _placeBombs();
  }

  final Matrix map;
  final int bombsCount;

  final Random _random = Random();

  Cell? cellByCoord(Coord coord) => map.getCell(coord);

  void _placeBombs() {
    final allCoords = <Coord>[];
    for (int x = 0; x < map.size.width; x++) {
      for (int y = 0; y < map.size.height; y++) {
        allCoords.add(Coord(x, y));
      }
    }
    allCoords.shuffle(_random);
    for (int i = 0; i < bombsCount; i++) {
      final bomb = allCoords[i];
      map.setCell(bomb, Cell.bomb);
      _placeNumbersAroundBomb(bomb);
    }
  }

  void _placeNumbersAroundBomb(Coord bomb) {
    for (final Coord around in bomb.getCoordsAround(map.size)) {
      if (cellByCoord(around) != Cell.bomb) {
        map.setCell(around, cellByCoord(around)!.getNextNum());
      }
    }
  }
}
