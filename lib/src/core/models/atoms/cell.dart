enum Cell {
  zero(imagePath: 'assets/img/zero.png'),
  num1(imagePath: 'assets/img/num1.png'),
  num2(imagePath: 'assets/img/num2.png'),
  num3(imagePath: 'assets/img/num3.png'),
  num4(imagePath: 'assets/img/num4.png'),
  num5(imagePath: 'assets/img/num5.png'),
  num6(imagePath: 'assets/img/num6.png'),
  num7(imagePath: 'assets/img/num7.png'),
  num8(imagePath: 'assets/img/num8.png'),
  bomb(imagePath: 'assets/img/bomb.png'),
  opened(imagePath: 'assets/img/opened.png'),
  closed(imagePath: 'assets/img/closed.png'),
  flagged(imagePath: 'assets/img/flagged.png'),
  bombed(imagePath: 'assets/img/bombed.png'),
  nobomb(imagePath: 'assets/img/nobomb.png');

  const Cell({required this.imagePath});

  final String imagePath;

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
