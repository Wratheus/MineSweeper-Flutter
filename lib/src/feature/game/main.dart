import 'package:flutter/material.dart';
import 'package:minesweeper/src/core/utils/sounds.dart';
import 'package:minesweeper/src/feature/game/provider/provider.dart';
import 'package:minesweeper/src/feature/game/widgets/screen.dart';
import 'package:provider/provider.dart';

class MineSweeperGamePlayMain extends StatefulWidget {
  const MineSweeperGamePlayMain({required this.routeObserver, super.key});

  final RouteObserver routeObserver;

  @override
  State<MineSweeperGamePlayMain> createState() =>
      _MineSweeperGamePlayMainState();
}

class _MineSweeperGamePlayMainState extends State<MineSweeperGamePlayMain>
    with RouteAware {
  bool _isActive = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final route = ModalRoute.of(context);
      if (route is PageRoute) {
        widget.routeObserver.subscribe(this, route);
      }
    });
  }

  @override
  void dispose() {
    widget.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    _onActive();
  }

  @override
  void didPopNext() {
    _onActive();
  }

  @override
  void didPushNext() {
    _onInactive();
  }

  @override
  void didPop() {
    _onInactive();
  }

  void _onActive() {
    if (_isActive) return;
    _isActive = true;
    SoundManager().play(AppMusic.game);
  }

  void _onInactive() {
    if (!_isActive) return;
    _isActive = false;
    SoundManager().stopBackground();
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (_) => GameProvider(),
    child: const MinesweeperGameplayScreen(),
  );
}
