import 'package:minesweeper/src/core/models/size.dart';

/// Уровень сложности игры.
///
/// Каждое значение перечисления определяет:
/// - Размер игрового поля [size].
/// - Количество мин [mines].
///
/// Используется для настройки игры при её запуске.
enum Difficulty {
  /// Новичок: 9x9 клеток, 10 мин, крупные изображения.
  beginner(size: BoardSize(2, 2), mines: 1),

  /// Средний: 16x16 клеток, 40 мин, изображения поменьше.
  intermediate(size: BoardSize(16, 16), mines: 40),

  /// Эксперт: 30x16 клеток, 99 мин.
  expert(size: BoardSize(30, 16), mines: 99);

  /// Конструктор для инициализации параметров уровня сложности.
  const Difficulty({required this.size, required this.mines});

  /// Размер игрового поля (ширина x высота).
  final BoardSize size;

  /// Количество мин на поле.
  final int mines;
}
