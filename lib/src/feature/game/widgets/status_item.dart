import 'package:flutter/material.dart';

class StatusItem extends StatelessWidget {
  const StatusItem({
    required this.icon,
    required this.text,
    this.color,
    super.key,
  });

  final IconData icon;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, color: color ?? IconTheme.of(context).color!),
      const SizedBox(width: 6),
      Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: color ?? IconTheme.of(context).color!,
        ),
      ),
    ],
  );
}
