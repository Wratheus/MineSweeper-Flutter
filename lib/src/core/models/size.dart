import 'package:flutter/cupertino.dart';

/// Класс [BoardSize] представляет размер игрового поля (ширина и высота).
@immutable
final class BoardSize {
  /// Создаёт объект размера игрового поля с указанной [width] и [height].
  const BoardSize(this.width, this.height);

  /// Ширина игрового поля (количество колонок).
  final int width;

  /// Высота игрового поля (количество строк).
  final int height;

  /// Возвращает общее количество клеток на поле (width * height).
  int get squareSize => width * height;

  @override
  String toString() => '${width}x$height';
}
