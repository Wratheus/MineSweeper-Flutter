import 'package:flutter/material.dart';
import 'package:minesweeper/src/core/utils/background_music.dart';
import 'package:minesweeper/src/feature/app/provider/provider.dart';
import 'package:minesweeper/src/feature/app/widgets/screen.dart';
import 'package:minesweeper/src/feature/menu/widgets/screen.dart';
import 'package:provider/provider.dart';

class MenuMain extends StatefulWidget {
  const MenuMain({super.key});

  @override
  State<MenuMain> createState() => _MenuMainState();
}

class _MenuMainState extends State<MenuMain> with RouteAware {
  final BackgroundMusicPlayer _bgMusic = BackgroundMusicPlayer();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);

    context.read<AppProvider>().addListener(_onAppProviderChanged);
  }

  @override
  void dispose() {
    context.read<AppProvider>().removeListener(_onAppProviderChanged);
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  void _onAppProviderChanged() {
    final appProvider = context.read<AppProvider>();
    if (!appProvider.soundOn) {
      _bgMusic.stop();
    } else {
      final route = ModalRoute.of(context);
      if (route?.isCurrent ?? false) {
        _bgMusic.play();
      }
    }
  }

  @override
  void didPush() {
    if (context.read<AppProvider>().soundOn) {
      _bgMusic.play();
    }
  }

  @override
  void didPopNext() {
    if (context.read<AppProvider>().soundOn) {
      _bgMusic.play();
    }
  }

  @override
  void didPushNext() {
    _bgMusic.stop();
  }

  @override
  void didPop() {
    _bgMusic.stop();
  }

  @override
  Widget build(BuildContext context) => const MenuScreen();
}
