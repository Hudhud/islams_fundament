import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:islams_fundament/providers/content_provider.dart';
import 'package:islams_fundament/screens/home_screen.dart';

void main() {
  runApp(const IslamsFundament());
}

class IslamsFundament extends StatelessWidget {
  const IslamsFundament({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ContentProvider(),
      child: MaterialApp(
        title: 'Islams Fundament',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
