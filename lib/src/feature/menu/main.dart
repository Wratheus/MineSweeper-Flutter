import 'package:flutter/material.dart';
import 'package:minesweeper/src/core/utils/sounds.dart';
import 'package:minesweeper/src/feature/menu/widgets/screen.dart';

class MenuMain extends StatefulWidget {
  const MenuMain({required this.routeObserver, super.key});

  final RouteObserver routeObserver;

  @override
  State<MenuMain> createState() => _MenuMainState();
}

class _MenuMainState extends State<MenuMain> with RouteAware {
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

  /// Экран стал видимым
  @override
  void didPush() {
    _onActive();
  }

  /// Возвратились на экран (pop другого экрана)
  @override
  void didPopNext() {
    _onActive();
  }

  /// Ушли с экрана (push нового)
  @override
  void didPushNext() {
    _onInactive();
  }

  /// Этот экран удален из стека
  @override
  void didPop() {
    _onInactive();
  }

  void _onActive() {
    if (_isActive) return;
    _isActive = true;
    SoundManager().play(AppMusic.menu);
  }

  void _onInactive() {
    if (!_isActive) return;
    _isActive = false;
    SoundManager().stopBackground();
  }

  @override
  Widget build(BuildContext context) =>
      MenuScreen(routeObserver: widget.routeObserver);
}
