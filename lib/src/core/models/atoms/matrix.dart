import 'dart:ui';

import 'package:minesweeper/src/core/models/atoms/cell.dart';
import 'package:minesweeper/src/core/models/atoms/coord.dart';

class Matrix {
  Matrix(Cell defaultCell, {required Size size})
    : matrix = List.generate(
        size.width.toInt(),
        (_) => List.generate(size.height.toInt(), (_) => defaultCell),
      ),
      width = size.width.toInt(),
      height = size.height.toInt();

  final List<List<Cell>> matrix;
  final int width;
  final int height;

  Size get size => Size(width.toDouble(), height.toDouble());

  Cell? getCell(Coord coord) =>
      _inRange(coord) ? matrix[coord.x][coord.y] : null;

  void setCell(Coord coord, Cell value) {
    if (_inRange(coord)) {
      matrix[coord.x][coord.y] = value;
    }
  }

  bool _inRange(Coord coord) =>
      coord.x >= 0 && coord.y >= 0 && coord.x < width && coord.y < height;
}
