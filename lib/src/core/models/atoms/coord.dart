import 'package:flutter/cupertino.dart';
import 'package:minesweeper/src/core/models/size.dart';

@immutable
class Coord {
  const Coord(this.x, this.y);

  final int x;
  final int y;

  Coord copyWith({int? x, int? y}) => Coord(x ?? this.x, y ?? this.y);

  @override
  String toString() => 'Coord(x: $x, y: $y)';

  static const _directions = [
    Offset(-1, -1),
    Offset(-1, 0),
    Offset(-1, 1),
    Offset(0, -1),
    Offset(0, 1),
    Offset(1, -1),
    Offset(1, 0),
    Offset(1, 1),
  ];

  List<Coord> getCoordsAround(BoardSize size) => _directions
      .map((d) => Coord(x + d.dx.toInt(), y + d.dy.toInt()))
      .where(
        (c) => c.x >= 0 && c.y >= 0 && c.x < size.width && c.y < size.height,
      )
      .toList();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Coord &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y;

  @override
  int get hashCode => Object.hash(x, y);
}
