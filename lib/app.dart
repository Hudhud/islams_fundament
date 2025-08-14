import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'screens/home_screen.dart';

class IslamsFundamentApp extends StatelessWidget {
  const IslamsFundamentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Islams Fundament',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const HomeScreen(),
    );
  }
}
