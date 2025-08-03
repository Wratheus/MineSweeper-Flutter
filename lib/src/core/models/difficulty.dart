import 'package:minesweeper/src/core/models/size.dart';

class Difficulty {
  const Difficulty._(this.size, this.mines);

  // Конструктор для кастомной сложности
  factory Difficulty.custom(int width, int height, int mines) =>
      Difficulty._(BoardSize(width, height), mines);

  final BoardSize size;
  final int mines;

  static const beginner = Difficulty._(BoardSize(9, 9), 10);
  static const intermediate = Difficulty._(BoardSize(16, 16), 40);
  static const expert = Difficulty._(BoardSize(30, 16), 99);
  static const deadEnd = Difficulty._(BoardSize(40, 25), 150);

  @override
  String toString() => 'Difficulty(size: $size, mines: $mines)';
}
