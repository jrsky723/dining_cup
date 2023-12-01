import 'package:dining_cup/constants/gaps.dart';
import 'package:dining_cup/constants/sizes.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Dining Cup',
          style: TextStyle(
            fontSize: Sizes.size20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal.shade400,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Dining Cup',
              style: TextStyle(
                fontSize: Sizes.size52,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            Gaps.v40,
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.restaurant,
                  size: 100.0,
                  color: Color(0xFF1AB394),
                ),
                Gaps.h20,
                Icon(
                  Icons.emoji_events,
                  size: 100.0,
                  color: Color(0xFF1AB394),
                ),
              ],
            ),
            Gaps.v48,
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade400,
                minimumSize: const Size(200.0, 50.0),
              ),
              child: const Text(
                'Start',
                style: TextStyle(
                  fontSize: Sizes.size20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Gaps.v20,
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade400,
                minimumSize: const Size(200.0, 50.0),
              ),
              child: const Text(
                'Exit',
                style: TextStyle(
                  fontSize: Sizes.size20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
