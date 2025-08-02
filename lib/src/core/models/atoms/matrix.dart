import 'package:minesweeper/src/core/models/atoms/cell.dart';
import 'package:minesweeper/src/core/models/atoms/coord.dart';
import 'package:minesweeper/src/core/models/size.dart';

class Matrix {
  Matrix(Cell defaultCell, {required this.size})
    : matrix = List.generate(
        size.width,
        (_) => List.generate(size.height, (_) => defaultCell),
      );

  final List<List<Cell>> matrix;
  final BoardSize size;

  Cell? getCell(Coord coord) =>
      _inRange(coord) ? matrix[coord.x][coord.y] : null;

  void setCell(Coord coord, Cell value) {
    if (_inRange(coord)) {
      matrix[coord.x][coord.y] = value;
    }
  }

  bool _inRange(Coord coord) =>
      coord.x >= 0 &&
      coord.y >= 0 &&
      coord.x < size.width &&
      coord.y < size.height;
}
