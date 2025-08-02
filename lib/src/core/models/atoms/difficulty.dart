
import 'package:minesweeper/src/core/models/size.dart';

enum Difficulty {
  beginner(size: BoardSize(9, 9), mines: 10, imageSize: 45),
  intermediate(size: BoardSize(16, 16), mines: 40, imageSize: 30),
  expert(size: BoardSize(30, 16), mines: 99, imageSize: 30);

  const Difficulty({
    required this.size,
    required this.mines,
    required this.imageSize,
  });

  final BoardSize size;
  final int mines;
  final int imageSize;
}
