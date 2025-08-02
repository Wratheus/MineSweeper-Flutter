import 'package:minesweeper/src/core/models/cell.dart';
import 'package:minesweeper/src/core/models/coord.dart';
import 'package:minesweeper/src/core/models/size.dart';

/// Класс [Matrix] представляет игровое поле в виде двумерной матрицы клеток.
class Matrix {
  /// Создаёт матрицу с заданным [size] и заполняет её значением [defaultCell].
  Matrix(Cell defaultCell, {required this.size})
    : matrix = List.generate(
        size.width,
        (_) => List.generate(size.height, (_) => defaultCell),
      );

  /// Двумерный список, представляющий игровое поле.
  final List<List<Cell>> matrix;

  /// Размер матрицы (ширина и высота).
  final BoardSize size;

  /// Возвращает клетку по координате [coord], если она находится в пределах матрицы.
  /// Иначе возвращает `null`.
  Cell? cellByCoord(Coord coord) =>
      _inRange(coord) ? matrix[coord.x][coord.y] : null;

  /// Устанавливает значение [value] для клетки по координате [coord],
  /// если она находится в пределах матрицы.
  void setCellByCoord(Coord coord, Cell value) {
    if (_inRange(coord)) {
      matrix[coord.x][coord.y] = value;
    }
  }

  /// Проверяет, находится ли координата [coord] внутри границ матрицы.
  bool _inRange(Coord coord) =>
      coord.x >= 0 &&
      coord.y >= 0 &&
      coord.x < size.width &&
      coord.y < size.height;
}
