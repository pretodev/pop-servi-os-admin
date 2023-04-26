import 'package:flutter/material.dart';

class AppTheme {
  // cores

  // instance do tema
  static final instance = ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.purple,
      elevation: 0,
      centerTitle: true,
    ),
  );
}
