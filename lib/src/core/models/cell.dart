/// Перечисление, описывающее все состояния ячеек в игре «Сапёр».
enum Cell {
  /// Пустая ячейка без соседних мин.
  zero(imagePath: 'assets/img/zero.png'),

  /// Ячейки с цифрами (от 1 до 8) — показывают количество мин вокруг.
  num1(imagePath: 'assets/img/num1.png'),
  num2(imagePath: 'assets/img/num2.png'),
  num3(imagePath: 'assets/img/num3.png'),
  num4(imagePath: 'assets/img/num4.png'),
  num5(imagePath: 'assets/img/num5.png'),
  num6(imagePath: 'assets/img/num6.png'),
  num7(imagePath: 'assets/img/num7.png'),
  num8(imagePath: 'assets/img/num8.png'),

  /// Мина (закрытая, пока игрок не проиграл).
  mine(imagePath: 'assets/img/mine.png'),

  /// Открытая пустая ячейка (фон без цифр).
  opened(imagePath: 'assets/img/opened.png'),

  /// Закрытая ячейка (стартовое состояние).
  closed(imagePath: 'assets/img/closed.png'),

  /// Помеченная игроком ячейка (флаг).
  flagged(imagePath: 'assets/img/flagged.png'),

  /// Взорванная мина (та, на которую кликнул игрок при проигрыше).
  exploded(imagePath: 'assets/img/exploded.png'),

  /// Ошибочный флаг (когда игрок поставил флаг на не-минe).
  mistake(imagePath: 'assets/img/mistake.png');

  /// Конструктор для каждой ячейки, связывающий её с путем к изображению.
  const Cell({required this.imagePath});

  /// Путь к изображению, отображающему текущее состояние ячейки.
  final String imagePath;

  /// Получить следующее числовое состояние для ячейки (увеличить счетчик).
  ///
  /// Используется при расстановке мин для подсчета количества соседних бомб.
  /// Например:
  /// - [zero] → [num1]
  /// - [num1] → [num2]
  /// ...
  ///
  /// Если попытаться вызвать для [mine], [opened], [closed] и т.д.,
  /// выбросит [StateError].
  Cell getNextNum() => switch (this) {
    Cell.zero => Cell.num1,
    Cell.num1 => Cell.num2,
    Cell.num2 => Cell.num3,
    Cell.num3 => Cell.num4,
    Cell.num4 => Cell.num5,
    Cell.num5 => Cell.num6,
    Cell.num6 => Cell.num7,
    Cell.num7 => Cell.num8,
    _ => throw StateError('Нет следующего значения для $this'),
  };
}
