import 'package:dining_cup/controllers/game_logic.dart';
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
  late GameLogic game;

  @override
  void initState() {
    super.initState();
    game =
        GameLogic(dinings: widget.dinings, worldCupSize: widget.worldCupSize);
    game.startTournament();
  }

  void onDiningSelected(DiningModel selectedDining) {
    setState(() {
      game.nextRoundDinings.add(selectedDining);
      game.prepareNextMatch();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: game.isTournamentEnd
            ? Text('1st: ${game.winner.placeName}')
            : Text('DINING CUP ${game.currentRoundDiningsNumber}강 '
                '${game.currentMatchNumber} / ${game.totalMatchesInRound}'),
      ),
      body: game.isTournamentEnd
          ? FutureBuilder(
              future: Future.delayed(const Duration(seconds: 2)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return WinnerScreen(winner: game.winner);
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
          : ListView.builder(
              itemCount: game.currentMatch.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(game.currentMatch[index].placeName),
                  // 식당 이미지 및 기타 정보 추가 가능
                  onTap: () => onDiningSelected(game.currentMatch[index]),
                );
              },
            ),
    );
  }
}
