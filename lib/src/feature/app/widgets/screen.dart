import 'package:flutter/material.dart';
import 'package:minesweeper/src/feature/app/provider/provider.dart';

import 'package:minesweeper/src/feature/menu/main.dart';
import 'package:provider/provider.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  @override
  void initState() {
    if (context.mounted) {
      context.read<AppProvider>().loadSettings();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Consumer<AppProvider>(
    builder: (context, appProvider, _) => MaterialApp(
      navigatorObservers: [routeObserver],
      title: 'minesweeper',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
      ),
      themeMode: appProvider.isDark ? ThemeMode.dark : ThemeMode.light,
      home: const MenuMain(),
    ),
  );
}
