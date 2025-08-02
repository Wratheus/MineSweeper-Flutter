import 'package:flutter/cupertino.dart';

@immutable
final class BoardSize {
  const BoardSize(this.width, this.height);

  final int width;
  final int height;

  int get squareSize => width * height;
}
