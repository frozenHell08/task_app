import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'homescreen.dart';

void main() {
  Logger.root.level = Level.WARNING;
  // Logger.root.onRecord.listen((record) {});
  runApp( MaterialApp(
    themeMode: ThemeMode.dark,
    darkTheme: ThemeData(
      brightness: Brightness.dark,

      primaryColor: Colors.indigo,
      appBarTheme: const AppBarTheme(
        color: Colors.black,
      ),
    ),
    home: const HomeScreen(),
  ));
}