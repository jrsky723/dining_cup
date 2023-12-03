import 'package:dining_cup/models/dining_model.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatelessWidget {
  final List<DiningModel> dinings;
  final int worldCupSize;

  const GameScreen(
      {super.key, required this.dinings, required this.worldCupSize});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('월드컵 대진표'),
      ),
    );
  }
}
