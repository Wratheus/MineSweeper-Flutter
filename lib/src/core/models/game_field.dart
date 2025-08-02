import 'package:minesweeper/src/core/models/atoms/difficulty.dart';
import 'package:minesweeper/src/core/models/bomb_map.dart';
import 'package:minesweeper/src/core/models/cell_map.dart';

class GameField {
  GameField({required this.difficulty})
    : bomb = BombMap(bombsCount: difficulty.mines, size: difficulty.size),
      flag = FlagMap(size: difficulty.size);

  final BombMap bomb;
  final FlagMap flag;
  final Difficulty difficulty;
}
