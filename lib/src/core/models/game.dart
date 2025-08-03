import 'dart:ui';

import 'package:minesweeper/src/core/models/cell.dart';
import 'package:minesweeper/src/core/models/coord.dart';
import 'package:minesweeper/src/core/models/difficulty.dart';
import 'package:minesweeper/src/core/models/flags.dart';
import 'package:minesweeper/src/core/models/mines.dart';

/// Состояние игры.
/// [start] — до первого хода,
/// [playing] — игра идет,
/// [lose] — игрок проиграл,
/// [win] — игрок выиграл.
enum GameState { start, playing, lose, win }

/// Основной класс, реализующий логику игры "Сапёр".
class Game {
  /// Создаёт новую игру с указанным уровнем сложности [difficulty].
  Game({required this.difficulty})
    : mine = Mines(mineCount: difficulty.mines, size: difficulty.size),
      flag = Flags(size: difficulty.size),
      _checked = List.filled(difficulty.size.squareSize, false);

  /// Карта бомб (нижний уровень — где находятся мины).
  final Mines mine;

  /// Карта флагов (верхний уровень — видимое состояние клеток).
  final Flags flag;

  /// Уровень сложности игры (размер поля + количество мин).
  final Difficulty difficulty;

  /// Список для отметки уже проверенных клеток (true — клетка открыта).
  final List<bool> _checked;

  /// Текущее состояние игры.
  GameState _state = GameState.start;

  /// Проверяет, открыта ли клетка по координате [c].
  bool _isChecked(Coord c) => _checked[c.x + c.y * difficulty.size.width];

  /// Помечает клетку [c] как открытую.
  void _setChecked(Coord c) =>
      _checked[c.x + c.y * difficulty.size.width] = true;

  /// Возвращает текущее состояние клетки:
  /// - Если клетка открыта, возвращаем значение из карты бомб.
  /// - Иначе возвращаем состояние из карты флагов.
  Cell getCell(Coord coord) {
    final Cell? cellByCoord = flag.get(coord);
    if (cellByCoord == null) {
      throw Exception('cellByCoord == null');
    }

    if (cellByCoord == Cell.opened) {
      return mine.cellByCoord(coord)!;
    } else {
      return flag.get(coord)!;
    }
  }

  /// Рекурсивно раскрывает соседние клетки вокруг [start],
  /// если текущая клетка — ноль (нет мин рядом).
  void _revealAround(Coord start) {
    final queue = <Coord>[start];
    _setChecked(start);

    while (queue.isNotEmpty) {
      queue.removeAt(0).forEachNeighbor(difficulty.size, (neighbor) {
        if (!_isChecked(neighbor) && flag.get(neighbor) != Cell.flagged) {
          _setChecked(neighbor);

          final Cell cellOnMinesMap = mine.cellByCoord(neighbor)!;
          if (cellOnMinesMap != Cell.mine) {
            flag.openCell(neighbor);

            if (cellOnMinesMap == Cell.zero) {
              queue.add(neighbor);
            }
          }
        }
      });
    }
  }

  /// Открывает клетку по клику.
  /// - На первом ходе меняет состояние игры на [GameState.playing].
  /// - Если клетка уже открыта, проверяет chording.
  /// - Если мина — проигрыш.
  /// - Если пустая клетка (0), раскрываем соседние.
  void openCell(Coord coord, {required VoidCallback onOpenCellCallback}) {
    switch (state) {
      case GameState.start:
        onOpenCellCallback();
        if (mine.cellByCoord(coord) != Cell.mine) {
          flag.openCell(coord);
          _setChecked(coord);
        }
        _revealAround(coord);
        _state = GameState.playing;
      case GameState.playing:
        if (flag.get(coord) == Cell.opened) {
          _chordIfFlagsMatch(coord);
        }
        if (flag.get(coord) == Cell.closed) {
          onOpenCellCallback();
          switch (mine.cellByCoord(coord)) {
            case Cell.mine:
              _lose(coord);
            case Cell.zero:
              flag.openCell(coord);
              _setChecked(coord);
              _revealAround(coord);
            default:
              flag.openCell(coord);
              _setChecked(coord);
          }
        }
      default:
        break;
    }
    _checkWin();
  }

  /// Chording: автоматическое открытие соседних клеток,
  /// если число флагов вокруг равно числу на клетке.
  void _chordIfFlagsMatch(Coord coord) {
    if (mine.cellByCoord(coord) != Cell.mine) {
      if (flag.countFlagCellsAround(coord) == mine.cellByCoord(coord)!.index) {
        coord.forEachNeighbor(difficulty.size, (around) {
          if (flag.get(around) == Cell.closed) {
            openCell(around, onOpenCellCallback: () {});
          }
        });
      }
    }
  }

  /// Обрабатывает проигрыш:
  /// - Все мины показываются.
  /// - Ошибочные флаги помечаются как "нет мины".
  /// - Кликнутая мина помечается как взорванная.
  @Deprecated('user [_lose()] method')
  // TODO(Aleksandr): will be removed.
  // ignore: unused_element
  void _loseWithDetonation(Coord mineClicked) {
    _state = GameState.lose;
    for (int x = 0; x < difficulty.size.width; x++) {
      for (int y = 0; y < difficulty.size.height; y++) {
        final Coord coord = Coord(x, y);
        if (mine.cellByCoord(coord) == Cell.mine) {
          flag.revealMine(coord);
        } else {
          flag.markNoMine(coord);
        }
      }
    }
    flag.detonateMine(mineClicked);
  }

  void _lose(Coord mineClicked) => _state = GameState.lose;

  /// Проверяет победу:
  /// Если количество открытых клеток равно количеству мин, ставим [GameState.win].
  void _checkWin() {
    if (state == GameState.playing) {
      int openedCells = 0;

      for (int x = 0; x < difficulty.size.width; x++) {
        for (int y = 0; y < difficulty.size.height; y++) {
          final Coord coord = Coord(x, y);
          if (flag.get(coord) == Cell.opened) {
            openedCells++;
          }
        }
      }

      final int totalCells = difficulty.size.squareSize;
      final int nonMineCells = totalCells - mine.mineCount;

      if (openedCells == nonMineCells) {
        _state = GameState.win;
      }
    }
  }

  /// Посчитать количество флагов на карте.
  int get countFlags {
    int count = 0;
    for (int x = 0; x < difficulty.size.width; x++) {
      for (int y = 0; y < difficulty.size.height; y++) {
        final Coord coord = Coord(x, y);
        if (flag.get(coord) == Cell.flagged) {
          count++;
        }
      }
    }
    return count;
  }

  /// Возвращает текущее состояние игры.
  GameState get state => _state;
}
