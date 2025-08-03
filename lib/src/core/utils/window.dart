import 'dart:math' as math;
import 'dart:ui';

import 'package:minesweeper/src/core/models/difficulty.dart';
import 'package:window_size/window_size.dart';

class WindowUtils {
  static Future<void> updateWindowSize(Difficulty difficulty) async {
    final screen = await getCurrentScreen();
    if (screen == null) return;

    const double verticalPadding = 155;
    const double spacing = 1;

    final totalSpacingHeight = (difficulty.size.height - 1) * spacing;
    final maxHeight = screen.frame.height - verticalPadding;
    final maxCellHeight =
        (maxHeight - totalSpacingHeight) / difficulty.size.height;

    final maxWidth = screen.frame.width - 155;
    final totalSpacingWidth = (difficulty.size.width - 1) * spacing;
    final maxCellWidth = (maxWidth - totalSpacingWidth) / difficulty.size.width;

    final cellSize = math.min(maxCellWidth, maxCellHeight).clamp(20, 45);

    final width = difficulty.size.width * cellSize + totalSpacingWidth;
    final height =
        difficulty.size.height * cellSize +
        totalSpacingHeight +
        verticalPadding;

    setWindowFrame(
      Rect.fromLTWH(
        (screen.frame.width - width) / 2,
        (screen.frame.height - height) / 2,
        width,
        height,
      ),
    );
  }
}
