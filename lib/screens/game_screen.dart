import 'package:dining_cup/screens/winner_screen.dart';
import 'package:flutter/material.dart';
import 'package:dining_cup/models/dining_model.dart';

class GameScreen extends StatefulWidget {
  final List<DiningModel> dinings;
  final int worldCupSize;

  const GameScreen(
      {Key? key, required this.dinings, required this.worldCupSize})
      : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<DiningModel> currentRoundDinings = [];
  List<DiningModel> nextRoundDinings = [];
  List<DiningModel> currentMatch = [];
  late DiningModel winner;
  bool isTournamentEnd = false;
  int currentRoundDiningsNumber = 0;
  int currentMatchNumber = 0;
  int totalMatchesInRound = 0;

  @override
  void initState() {
    super.initState();
    startTournament();
  }

  void startTournament() {
    nextRoundDinings = List.from(widget.dinings);
    nextRoundDinings.shuffle();
    nextRoundDinings = nextRoundDinings.take(widget.worldCupSize).toList();
    startNextRound();
  }

  void startNextRound() {
    if (nextRoundDinings.length == 1) {
      setState(() {
        winner = nextRoundDinings.first;
        isTournamentEnd = true;
      });
      return;
    }
    setState(() {
      currentRoundDinings = List.from(nextRoundDinings);
      currentRoundDinings.shuffle();
      currentRoundDiningsNumber = currentRoundDinings.length;
      nextRoundDinings.clear();
      currentMatchNumber = 0;
      totalMatchesInRound = (currentRoundDiningsNumber / 2).ceil();
      prepareNextMatch();
    });
  }

  void prepareNextMatch() {
    if (currentRoundDinings.isEmpty) {
      startNextRound();
    } else {
      currentMatch = currentRoundDinings.take(2).toList();
      currentRoundDinings = currentRoundDinings.skip(2).toList();
      currentMatchNumber++;
    }
  }

  void onDiningSelected(DiningModel selectedDining) {
    setState(() {
      nextRoundDinings.add(selectedDining);
      prepareNextMatch();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isTournamentEnd
            ? Text('1st: ${winner.placeName}')
            : Text(
                'DINING CUP $currentRoundDiningsNumber강 $currentMatchNumber / $totalMatchesInRound'),
      ),
      body: isTournamentEnd
          ? FutureBuilder(
              future: Future.delayed(const Duration(seconds: 2)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return WinnerScreen(winner: winner);
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
          : ListView.builder(
              itemCount: currentMatch.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(currentMatch[index].placeName),
                  // 식당 이미지 및 기타 정보 추가 가능
                  onTap: () => onDiningSelected(currentMatch[index]),
                );
              },
            ),
    );
  }
}
