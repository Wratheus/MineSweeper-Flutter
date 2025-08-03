import 'package:flutter/material.dart';
import 'package:minesweeper/src/feature/app/provider/provider.dart';
import 'package:minesweeper/src/feature/app/widgets/screen.dart';
import 'package:provider/provider.dart';

class AppMain extends StatelessWidget {
  const AppMain({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => AppProvider(),
    child: AppScreen(),
  );
}
