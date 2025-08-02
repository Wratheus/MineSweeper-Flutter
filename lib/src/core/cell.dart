import 'package:flutter/widgets.dart';

enum Cell {
  zero(image: AssetImage('assets/img/zero.png')),
  num1(image: AssetImage('assets/img/num1.png')),
  num2(image: AssetImage('assets/img/num2.png')),
  num3(image: AssetImage('assets/img/num3.png')),
  num4(image: AssetImage('assets/img/num4.png')),
  num5(image: AssetImage('assets/img/num5.png')),
  num6(image: AssetImage('assets/img/num6.png')),
  num7(image: AssetImage('assets/img/num7.png')),
  num8(image: AssetImage('assets/img/num8.png')),
  bomb(image: AssetImage('assets/img/bomb.png')),
  opened(image: AssetImage('assets/img/opened.png')),
  closed(image: AssetImage('assets/img/closed.png')),
  flagged(image: AssetImage('assets/img/flagged.png')),
  bombed(image: AssetImage('assets/img/bombed.png')),
  nobomb(image: AssetImage('assets/img/nobomb.png'));

  const Cell({required this.image});

  final AssetImage image;

  /// Возвращает следующий номер
  Cell getNextNum() {
    final index = this.index + 1;
    if (index < Cell.values.length) {
      return Cell.values[index];
    } else {
      throw StateError('Нет следующего значения для $this');
    }
  }

  int get number => index;
}
