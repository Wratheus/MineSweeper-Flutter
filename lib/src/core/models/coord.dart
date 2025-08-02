import 'package:flutter/cupertino.dart';
import 'package:minesweeper/src/core/models/matrix.dart';
import 'package:minesweeper/src/core/models/size.dart';

/// Класс, представляющий координату (x, y) на игровом поле.
///
/// Используется для доступа к ячейкам в [Matrix].
@immutable
class Coord {
  /// Создает объект координаты с заданными значениями [x] и [y].
  const Coord(this.x, this.y);

  /// Позиция по горизонтали (столбец).
  final int x;

  /// Позиция по вертикали (строка).
  final int y;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Coord && other.x == x && other.y == y;
  }

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => 'Coord($x, $y)';
}

/// Расширение для работы с соседними клетками относительно текущей координаты.
///
/// В игре «Сапёр» у каждой клетки есть до 8 соседей (по диагонали и по прямым направлениям).
extension CoordNeighbors on Coord {
  /// Вызывает [action] для всех соседних координат вокруг текущей.
  ///
  /// - [size] — размер игрового поля, чтобы не выйти за границы.
  /// - [action] — функция, применяемая к каждой валидной соседней координате.
  ///
  /// Пример использования:
  /// ```dart
  /// coord.forEachNeighbor(boardSize, (neighbor) {
  ///   print('Сосед: $neighbor');
  /// });
  /// ```
  void forEachNeighbor(BoardSize size, void Function(Coord) action) {
    const directions = [
      Coord(-1, -1), // верхний левый
      Coord(-1, 0), // левый
      Coord(-1, 1), // нижний левый
      Coord(0, -1), // верхний
      Coord(0, 1), // нижний
      Coord(1, -1), // верхний правый
      Coord(1, 0), // правый
      Coord(1, 1), // нижний правый
    ];

    for (final d in directions) {
      final int nx = x + d.x;
      final int ny = y + d.y;
      // Проверка на выход за границы поля.
      if (nx >= 0 && ny >= 0 && nx < size.width && ny < size.height) {
        action(Coord(nx, ny));
      }
    }
  }
}
