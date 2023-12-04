import 'package:dining_cup/models/dining_model.dart';

class GameLogic {
  List<DiningModel> currentRoundDinings = [];
  List<DiningModel> nextRoundDinings = [];
  List<DiningModel> currentMatch = [];
  late DiningModel winner;
  bool isTournamentEnd = false;
  int currentRoundDiningsNumber = 0;
  int currentMatchNumber = 0;
  int totalMatchesInRound = 0;
  final List<DiningModel> dinings;

  GameLogic({required this.dinings});

  void startTournament() {
    nextRoundDinings = List.from(dinings);
    startNextRound();
  }

  void startNextRound() {
    if (nextRoundDinings.length == 1) {
      winner = nextRoundDinings.first;
      isTournamentEnd = true;
      return;
    }
    currentRoundDinings = List.from(nextRoundDinings);
    currentRoundDinings.shuffle();
    currentRoundDiningsNumber = currentRoundDinings.length;
    nextRoundDinings.clear();
    currentMatchNumber = 0;
    totalMatchesInRound = (currentRoundDiningsNumber / 2).ceil();
    prepareNextMatch();
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
}
