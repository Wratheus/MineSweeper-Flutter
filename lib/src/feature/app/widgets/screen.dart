import 'package:flutter/material.dart';
import 'package:minesweeper/src/feature/app/provider/provider.dart';

import 'package:minesweeper/src/feature/menu/main.dart';
import 'package:provider/provider.dart';

class AppScreen extends StatelessWidget {
  AppScreen({super.key});

  final RouteObserver routeObserver = RouteObserver();

  @override
  Widget build(BuildContext context) => Consumer<AppProvider>(
    builder: (context, appProvider, _) => MaterialApp(
      navigatorObservers: [routeObserver],
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
      home: const MenuMain(),
    ),
  );
}
