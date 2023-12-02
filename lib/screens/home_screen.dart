import 'package:dining_cup/constants/gaps.dart';
import 'package:dining_cup/constants/sizes.dart';
import 'package:dining_cup/screens/setup_screen.dart';
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
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Dining Cup',
              style: TextStyle(
                fontSize: Sizes.size52,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Gaps.v40,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.restaurant,
                  size: 100.0,
                  color: Theme.of(context).primaryColor,
                ),
                Gaps.h20,
                Icon(
                  Icons.emoji_events,
                  size: 100.0,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
            Gaps.v96,
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SetupScreen()));
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200.0, 50.0),
              ),
              child: const Text(
                'Set Up',
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
