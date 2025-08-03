import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:minesweeper/src/core/models/game.dart';

class CustomConfettiWidget extends StatefulWidget {
  const CustomConfettiWidget({
    required this.game,
    required this.child,
    super.key,
  });

  final Game game;
  final Widget child;

  @override
  State<CustomConfettiWidget> createState() => _CustomConfettiWidgetState();
}

class _CustomConfettiWidgetState extends State<CustomConfettiWidget> {
  late ConfettiController confettiController;

  @override
  void initState() {
    super.initState();
    confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.game.state == GameState.win &&
        confettiController.state != ConfettiControllerState.playing) {
      confettiController.play();
    }

    return Stack(
      children: [
        widget.child,
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            numberOfParticles: 30,
            gravity: 0.4,
            emissionFrequency: 0.05,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.orange,
              Colors.purple,
            ],
          ),
        ),
      ],
    );
  }
}
