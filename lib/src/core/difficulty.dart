import 'dart:ui';

enum Difficulty {
  beginner(size: Size(9, 9), mines: 10, imageSize: 45),
  intermediate(size: Size(16, 16), mines: 40, imageSize: 30),
  expert(size: Size(30, 16), mines: 99, imageSize: 30);

  const Difficulty({
    required this.size,
    required this.mines,
    required this.imageSize,
  });

  final Size size;
  final int mines;
  final int imageSize;


}
