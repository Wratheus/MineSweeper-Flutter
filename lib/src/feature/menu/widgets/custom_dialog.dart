import 'package:flutter/material.dart';
import 'package:minesweeper/src/core/models/difficulty.dart';

class CustomDifficultyDialog extends StatefulWidget {
  const CustomDifficultyDialog({required this.onStart, super.key});

  final void Function(Difficulty difficulty) onStart;

  @override
  State<CustomDifficultyDialog> createState() => _CustomDifficultyDialogState();
}

class _CustomDifficultyDialogState extends State<CustomDifficultyDialog> {
  late TextEditingController widthController;
  late TextEditingController heightController;
  late TextEditingController minesController;

  String? errorText;

  @override
  void initState() {
    super.initState();
    widthController = TextEditingController(text: '10');
    heightController = TextEditingController(text: '10');
    minesController = TextEditingController(text: '10');
  }

  @override
  void dispose() {
    widthController.dispose();
    heightController.dispose();
    minesController.dispose();
    super.dispose();
  }

  void _tryStartGame() {
    final width = int.tryParse(widthController.text);
    final height = int.tryParse(heightController.text);
    final mines = int.tryParse(minesController.text);

    setState(() {
      errorText = null;
    });

    if (width == null || width <= 0) {
      setState(() {
        errorText = 'Width must be a positive number';
      });
      return;
    }
    if (height == null || height <= 0) {
      setState(() {
        errorText = 'Height must be a positive number';
      });
      return;
    }
    if (mines == null || mines <= 0) {
      setState(() {
        errorText = 'Mines must be a positive number';
      });
      return;
    }
    if (mines >= width * height) {
      setState(() {
        errorText = 'Mines must be less than width × height';
      });
      return;
    }

    widget.onStart(Difficulty.custom(width, height, mines));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Center(
        child: Text(
          'Difficulty',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildNumberField(
              controller: widthController,
              label: 'Width',
              icon: Icons.grid_on,
            ),
            const SizedBox(height: 12),
            _buildNumberField(
              controller: heightController,
              label: 'Height',
              icon: Icons.view_day,
            ),
            const SizedBox(height: 12),
            _buildNumberField(
              controller: minesController,
              label: 'Mines',
              icon: Icons.brightness_high,
            ),
            if (errorText != null) ...[
              const SizedBox(height: 12),
              Text(
                errorText!,
                style: TextStyle(
                  color: theme.colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _tryStartGame,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text('Start', style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }

  Widget _buildNumberField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) => TextField(
    controller: controller,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    ),
  );
}
