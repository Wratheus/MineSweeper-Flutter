import 'package:flutter/cupertino.dart';

@immutable
class Coord {
  const Coord(this.x, this.y);

  final int x;
  final int y;

  Coord copyWith({int? x, int? y}) => Coord(x ?? this.x, y ?? this.y);

  @override
  String toString() => 'Coord(x: $x, y: $y)';

  List<Coord> getCoordsAround(Size size) {
    final listCoords = <Coord>[];
    for (int x = this.x - 1; x <= this.x + 1; x++) {
      for (int y = this.y - 1; y <= this.y + 1; y++) {
        if (x >= 0 &&
            y >= 0 &&
            x < size.width &&
            y < size.height &&
            (x != this.x || y != this.y)) {
          listCoords.add(Coord(x, y));
        }
      }
    }
    return listCoords;
  }

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
