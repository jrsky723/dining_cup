import 'package:dining_cup/models/dining_model.dart';
import 'package:dining_cup/screens/search_screen.dart';
import 'package:flutter/material.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  // 위치, 거리, 카테고리, 월드컵 대진 등을 저장할 변수들을 선언합니다.

  List<DiningModel> dinings = []; // 맛집 리스트

  String selectedLocation = '현재 위치'; // 현재 위치 또는 임의의 위치
  int selectedDistance = 100; // 거리 (예: 100m, 300m 등)
  // 기타 필요한 변수들 추가...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('월드컵 대진표 설정'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // 탐색 버튼
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // 탐색 버튼 클릭 시의 로직
                  var result = Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SearchScreen()));
                  result.then((value) {
                    if (value != null) {
                      setState(() {
                        dinings = value;
                      });
                    }
                  });
                },
                child: const Text('식당 탐색'),
              ),
            ),

            // 월드컵 시작 버튼
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // 월드컵 시작 버튼 클릭 시의 로직
                },
                child: const Text('월드컵 시작'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
