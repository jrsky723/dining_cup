import 'package:dining_cup/constants/gaps.dart';
import 'package:dining_cup/models/dining_model.dart';
import 'package:flutter/material.dart';

class DiningText extends StatelessWidget {
  final DiningModel dining;

  const DiningText({super.key, required this.dining});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildTextWithStroke(dining.placeName, 23),
        Gaps.v10,
        _buildTextWithStroke(dining.categoryName, 20),
        Gaps.v10,
        _buildTextWithStroke('거리: ${dining.distance}m', 18),
        Gaps.v10,
        _buildTextWithStroke(dining.addressName, 20),
      ],
    );
  }

  Widget _buildTextWithStroke(String text, double fontSize) {
    return Stack(
      children: <Widget>[
        // Text with stroke (border)
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2
              ..color = Colors.black,
          ),
        ),
        // Solid text
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: const [
              Shadow(
                blurRadius: 5.0,
                color: Colors.black,
                offset: Offset(2.0, 2.0),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
