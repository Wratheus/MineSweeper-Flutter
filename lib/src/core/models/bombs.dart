import 'dart:math';

import 'package:minesweeper/src/core/models/cell.dart';
import 'package:minesweeper/src/core/models/coord.dart';
import 'package:minesweeper/src/core/models/matrix.dart';
import 'package:minesweeper/src/core/models/size.dart';

/// Класс для генерации и хранения карты мин (нижний уровень игрового поля).
class Bombs {
  Bombs({required this.bombsCount, required BoardSize size})
      : map = Matrix(Cell.zero, size: size) {
    _placeBombs();
  }

  /// Двумерная карта, где каждая ячейка имеет значение типа [Cell].
  /// - Изначально все ячейки — [Cell.zero].
  /// - После расстановки мин часть ячеек станет [Cell.bomb],
  ///   а вокруг мин — [Cell.num1]..[Cell.num8].
  final Matrix map;

  /// Количество бомб, которые нужно разместить.
  final int bombsCount;

  /// Генератор случайных чисел для выбора позиций мин.
  final Random _random = Random();

  /// Получить ячейку по координате.
  /// Возвращает `null`, если координата вне поля.
  Cell? cellByCoord(Coord coord) => map.cellByCoord(coord);

  /// Расставляет бомбы случайным образом и обновляет цифры вокруг них.
  void _placeBombs() {
    final Set<Coord> placed = <Coord>{}; // множество уже занятых координат

    while (placed.length < bombsCount) {
      final int x = _random.nextInt(map.size.width);
      final int y = _random.nextInt(map.size.height);
      final Coord coord = Coord(x, y);

      // Если на этой позиции еще нет бомбы, добавляем
      if (!placed.contains(coord)) {
        placed.add(coord);
        map.setCellByCoord(coord, Cell.bomb);
        _placeNumbersAroundBomb(coord);
      }
    }
  }

  /// Увеличивает значения соседних ячеек вокруг бомбы.
  ///
  /// Если соседняя клетка не является бомбой, то её состояние повышается:
  /// - zero → num1
  /// - num1 → num2
  /// - и т.д. до num8.
  void _placeNumbersAroundBomb(Coord bomb) {
    bomb.forEachNeighbor(map.size, (around) {
      if (cellByCoord(around) != Cell.bomb) {
        map.setCellByCoord(around, cellByCoord(around)!.getNextNum());
      }
    });
  }
}
