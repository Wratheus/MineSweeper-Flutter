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

extension CoordNeighbors on Coord {
  void forEachNeighbor(BoardSize size, void Function(Coord) action) {
    const directions = [
      Offset(-1, -1),
      Offset(-1, 0),
      Offset(-1, 1),
      Offset(0, -1),
      Offset(0, 1),
      Offset(1, -1),
      Offset(1, 0),
      Offset(1, 1),
    ];

    for (final d in directions) {
      final nx = x + d.dx.toInt();
      final ny = y + d.dy.toInt();
      if (nx >= 0 && ny >= 0 && nx < size.width && ny < size.height) {
        action(Coord(nx, ny));
      }
    }
  }
}
