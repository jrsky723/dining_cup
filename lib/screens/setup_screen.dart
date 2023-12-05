import 'dart:developer';

import 'package:dining_cup/constants/gaps.dart';
import 'package:dining_cup/constants/sizes.dart';
import 'package:dining_cup/models/dining_model.dart';
import 'package:dining_cup/screens/game_screen.dart';
import 'package:dining_cup/screens/search_screen.dart';
import 'package:dining_cup/services/naver_search_api.dart';
import 'package:flutter/material.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  List<DiningModel> dinings = [];
  int selectedWorldCupSize = 0; // 사용자가 선택할 수 있는 월드컵 규모

  final List<int> availableSizes = [
    4,
    8,
    16,
    32,
    64,
    128,
    256,
  ]; // 가능한 월드컵 규모 목록

  bool isLoading = false;

  List<int> getFilteredSizes() {
    List<int> filteredSizes =
        availableSizes.where((size) => size < dinings.length).toList();
    filteredSizes.add(dinings.length);
    return filteredSizes;
  }

  String createQuery(DiningModel dining) {
    String placeName = dining.placeName;
    String categoryName =
        dining.categoryName.replaceAll(' >', '').replaceAll(',', '');
    String vilage = dining.addressName.split(' ').reversed.toList()[1];
    vilage = vilage.substring(0, vilage.length - 1);

    String query = '$vilage $categoryName $placeName';
    return query;
  }

  onStartButtonPressed() async {
    setState(() {
      isLoading = true; // 로딩 시작
    });

    List<DiningModel> gameDinings = List.from(dinings);
    gameDinings.shuffle();
    gameDinings = gameDinings.take(selectedWorldCupSize).toList();

    for (var dining in gameDinings) {
      try {
        String query = createQuery(dining);
        final imageUrls = await NaverSeacrhApi.searchDiningImages(query);
        if (imageUrls.isNotEmpty) {
          dining.imageUrls = imageUrls;
        }
      } catch (e) {
        log('Failed to search dining images: $e');
      }
    }

    if (!mounted) return;

    setState(() {
      isLoading = false; // 로딩 종료
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(
          dinings: gameDinings,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<int> filteredSizes = getFilteredSizes();

    if (!filteredSizes.contains(selectedWorldCupSize)) {
      selectedWorldCupSize = filteredSizes.isNotEmpty ? filteredSizes.first : 0;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('월드컵 대진표 설정'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(Sizes.size16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchScreen(),
                      ),
                    );
                    if (result != null) {
                      setState(() {
                        dinings = result;
                      });
                    }
                  },
                  child: const Text('식당 탐색'),
                ),
                Gaps.v20,
                Center(
                  child: Text(
                    '선택된 식당: ${dinings.length}개',
                    style: const TextStyle(
                      fontSize: Sizes.size20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Gaps.v20,
                if (dinings.isEmpty)
                  const Expanded(
                    child: Center(
                      child: Text(
                        '식당을 탐색해 주세요.',
                        style: TextStyle(fontSize: Sizes.size20),
                      ),
                    ),
                  ),
                // dinings가 비어있지 않을 때만 ListView를 보여줍니다.
                if (dinings.isNotEmpty) ...[
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: dinings.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            child: ListTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      dinings[index].placeName,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Gaps.h10,
                                  Text(
                                    '${dinings[index].distance}m',
                                    style: const TextStyle(
                                      fontSize: Sizes.size14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                  '${dinings[index].addressName} (${dinings[index].categoryName})'),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 140.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: Sizes.size10, horizontal: Sizes.size5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            '총 라운드를 선택하세요.',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: filteredSizes.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(Sizes.size4),
                                  child: ChoiceChip(
                                    label: Text('${filteredSizes[index]} 강'),
                                    selected: selectedWorldCupSize ==
                                        filteredSizes[index],
                                    onSelected: (selected) {
                                      setState(() {
                                        selectedWorldCupSize =
                                            filteredSizes[index];
                                      });
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                          ElevatedButton(
                              onPressed: onStartButtonPressed,
                              child: const Text('시작하기')),
                        ],
                      ),
                    ),
                  )
                ],
              ],
            ),
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
