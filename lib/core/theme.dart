import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF212121);
const Color accentColor = Color(0xFFF57C00);
const Color backgroundColor = Color(0xFFFFF8E1);
const Color textColor = Color(0xFF212121);

final ThemeData appTheme = ThemeData(
  primaryColor: primaryColor,
  scaffoldBackgroundColor: backgroundColor,
  colorScheme:
      ColorScheme.fromSwatch(
        primarySwatch: Colors.orange,
        accentColor: accentColor,
        backgroundColor: backgroundColor,
        brightness: Brightness.light,
      ).copyWith(
        primary: primaryColor,
        secondary: accentColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
      ),

  fontFamily: 'Lato',
  textTheme: const TextTheme(
    displayLarge: TextStyle(color: textColor, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(color: textColor, fontWeight: FontWeight.bold),
    titleLarge: TextStyle(color: textColor, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(color: textColor, fontSize: 18.0, height: 1.6),
    bodyMedium: TextStyle(color: textColor, fontSize: 16.0, height: 1.5),
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    elevation: 2,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontFamily: 'Lato',
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),

  cardTheme: CardThemeData(
    elevation: 2,
    color: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: const EdgeInsets.symmetric(vertical: 8.0),
  ),

  listTileTheme: const ListTileThemeData(iconColor: accentColor),

  iconTheme: const IconThemeData(color: accentColor),
);
