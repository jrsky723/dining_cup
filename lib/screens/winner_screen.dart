import 'dart:developer';

import 'package:dining_cup/constants/gaps.dart';
import 'package:dining_cup/constants/sizes.dart';
import 'package:dining_cup/models/dining_model.dart';
import 'package:dining_cup/widgets/image_slider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class WinnerScreen extends StatelessWidget {
  final DiningModel winner;

  const WinnerScreen({
    super.key,
    required this.winner,
  });

  void onUrlButtonPressed(urlString) async {
    // chage http to https
    if (await canLaunchUrlString(urlString)) {
      await launchUrlString(urlString);
    } else {
      log('Could not launch $urlString');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 여러 이미지 슬라이더 표시 // flexiable
            Flexible(
              flex: 2,
              child: ImageSlider(
                imageUrls: winner.imageUrls,
              ),
            ),

            const Divider(
              height: 0.0,
            ),

            Flexible(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(Sizes.size32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      winner.placeName,
                      style: const TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gaps.v20,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          '위치',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Gaps.h10,
                        Text(
                          '(${winner.distance}m)',
                        ),
                      ],
                    ),
                    Gaps.v10,
                    Row(
                      children: [
                        const Column(
                          children: [
                            Icon(Icons.location_on),
                            Icon(Icons.location_on_outlined),
                          ],
                        ),
                        Gaps.h10,
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('지번'),
                            Text('도로명'),
                          ],
                        ),
                        Gaps.h5,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('| ${winner.roadAddressName}'),
                            Text('| ${winner.addressName}'),
                          ],
                        ),
                      ],
                    ),
                    Gaps.v20,
                    const Text(
                      '카테고리',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gaps.v10,
                    Row(
                      children: [
                        const Icon(Icons.restaurant),
                        Gaps.h10,
                        Text(winner.categoryName),
                      ],
                    ),
                    Gaps.v40,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            onUrlButtonPressed(winner.placeUrl);
                          },
                          child: const Text('자세히'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('완료'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
