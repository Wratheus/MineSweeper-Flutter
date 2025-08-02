import 'package:minesweeper/src/core/models/cell.dart';
import 'package:minesweeper/src/core/models/coord.dart';
import 'package:minesweeper/src/core/models/matrix.dart';
import 'package:minesweeper/src/core/models/size.dart';

/// Класс для управления верхним уровнем игрового поля.
/// Этот уровень хранит видимое состояние ячеек:
/// - закрытые
/// - открытые
/// - с флагами
/// - с отметками после проигрыша (например, `nobomb`)
class Flags {
  /// Создаёт карту флагов с начальными значениями [Cell.closed].
  Flags({required this.size}) : map = Matrix(Cell.closed, size: size);

  /// Матрица, представляющая текущее состояние верхнего уровня.
  final Matrix map;

  /// Размер игрового поля.
  final BoardSize size;

  /// Возвращает состояние клетки по координате [coord].
  Cell? get(Coord coord) => map.cellByCoord(coord);

  /// Открывает клетку (меняет её состояние на [Cell.opened]).
  void openCell(Coord coord) => map.setCellByCoord(coord, Cell.opened);

  /// Переключает состояние флага:
  /// - Если клетка помечена флагом → делает её закрытой.
  /// - Если клетка закрыта → ставит флаг.
  void toggleFlag(Coord coord) {
    final Cell? current = map.cellByCoord(coord);
    if (current == Cell.flagged) {
      map.setCellByCoord(coord, Cell.closed);
    } else if (current == Cell.closed) {
      map.setCellByCoord(coord, Cell.flagged);
    }
  }

  /// Отмечает клетку как "здесь не было бомбы" ([Cell.nobomb]),
  /// если игрок ошибочно поставил флаг.
  /// Используется при проигрыше.
  void markNoBomb(Coord coord) {
    if (map.cellByCoord(coord) == Cell.flagged) {
      map.setCellByCoord(coord, Cell.nobomb);
    }
  }

  /// Помечает клетку как подорванную бомбу ([Cell.bombed]).
  /// Используется для выделения той мины, на которую кликнул игрок.
  void detonateBomb(Coord coord) {
    map.setCellByCoord(coord, Cell.bombed);
  }

  /// Показывает мину на поле, если она была закрыта.
  /// (Меняет состояние на [Cell.opened]).
  /// Вызывается при проигрыше для раскрытия всех мин.
  void revealBomb(Coord coord) {
    if (map.cellByCoord(coord) == Cell.closed) {
      map.setCellByCoord(coord, Cell.opened);
    }
  }

  /// Считает количество флагов вокруг указанной клетки.
  /// Используется для chording (автооткрытия соседних клеток).
  int countFlagCellsAround(Coord coord) {
    int count = 0;
    coord.forEachNeighbor(size, (around) {
      if (map.cellByCoord(around) == Cell.flagged) {
        count++;
      }
    });
    return count;
  }
}
