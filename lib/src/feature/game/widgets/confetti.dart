import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:minesweeper/src/core/models/game.dart';

class Confetti extends StatefulWidget {
  const Confetti({
    required this.game,
    required this.child,
    super.key,
  });

  final Game game;
  final Widget child;

  @override
  State<Confetti> createState() => _ConfettiState();
}

class _ConfettiState extends State<Confetti> {
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
  void didChangeDependencies() {
    if (widget.game.state == GameState.win &&
        confettiController.state != ConfettiControllerState.playing) {
      confettiController.play();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) => Stack(
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
