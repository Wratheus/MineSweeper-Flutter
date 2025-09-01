import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Обёртка, которая ограничивает максимальные размеры контента на вебе.
/// На мобильных/десктопных билдах возвращает `child` без изменений.
class WebMaxWidth extends StatelessWidget {
  const WebMaxWidth({
    required this.child,
    super.key,
    this.maxWidth = 1000,
    this.maxHeight,
    this.padding = EdgeInsets.zero,
  });

  final Widget child;
  final double? maxWidth;
  final double? maxHeight;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return child;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? double.infinity,
          maxHeight: maxHeight ?? double.infinity,
        ),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
