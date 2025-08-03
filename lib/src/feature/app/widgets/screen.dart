import 'package:flutter/material.dart';
import 'package:minesweeper/src/feature/app/provider/provider.dart';

import 'package:minesweeper/src/feature/game/main.dart';
import 'package:provider/provider.dart';

class AppScreen extends StatelessWidget {
  const AppScreen({super.key});

  @override
  Widget build(BuildContext context) => Consumer<AppProvider>(
    builder: (context, appProvider, _) => MaterialApp(
      title: 'Minesweeper',
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
      home: const MineSweeperGamePlayMain(),
    ),
  );
}
