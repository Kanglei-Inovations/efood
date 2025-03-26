import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.orange,
    fontFamily: 'Roboto',
    textTheme: const TextTheme(
      headline1: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      bodyText1: TextStyle(fontSize: 16),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.orange,
      textTheme: ButtonTextTheme.primary,
    ),
  );
}
