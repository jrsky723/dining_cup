import 'package:dining_cup/constants/sizes.dart';
import 'package:dining_cup/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const DiningCupApp());
}

class DiningCupApp extends StatelessWidget {
  const DiningCupApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dining Cup',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color(0xFF1AB394),
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: Sizes.size20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
