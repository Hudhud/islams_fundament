import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:islams_fundament/firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:islams_fundament/providers/content_provider.dart';
import 'package:islams_fundament/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF003D5B),
            primary: const Color(0xFF003D5B),
            secondary: const Color(0xFFD5A100),
            surface: const Color(0xFFF5F5F5),
          ),
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
