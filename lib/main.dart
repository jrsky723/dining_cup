import 'package:dining_cup/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const DiningCupApp());
}

class DiningCupApp extends StatelessWidget {
  const DiningCupApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}
