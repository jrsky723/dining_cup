import 'dart:developer';

import 'package:dining_cup/controllers/game_logic.dart';
import 'package:dining_cup/screens/winner_screen.dart';
import 'package:dining_cup/widgets/image_slider.dart';
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

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late GameLogic game;
  late AnimationController animationController;
  late Animation<double> inAnimation, outAnimation;
  DiningModel? selectedDining;
  bool isAnimated = false;

  @override
  void initState() {
    super.initState();
    game =
        GameLogic(dinings: widget.dinings, worldCupSize: widget.worldCupSize);
    game.startTournament();

    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));

    inAnimation = Tween(begin: 0.0, end: 150.0).animate(
      CurvedAnimation(
          parent: animationController,
          curve: Curves.fastEaseInToSlowEaseOut // 끝날 때 천천히 안착하는 효과
          ),
    );
    outAnimation = Tween(begin: 0.0, end: -1000.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );

    void animationListener() {
      setState(() {});
    }

    inAnimation.addListener(animationListener);
    outAnimation.addListener(animationListener);
  }

  void onDiningSelected(DiningModel selectedDining) {
    this.selectedDining = selectedDining;
    isAnimated = true;
    animationController.forward().then((_) {
      setState(() {
        game.nextRoundDinings.add(selectedDining);
        game.prepareNextMatch();
        this.selectedDining = null;
      });
      animationController.reset();
      isAnimated = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: game.isTournamentEnd ? Colors.white : Colors.black,
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
            : Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildDiningSlider(0, game.currentMatch.first),
                        buildDiningSlider(1, game.currentMatch.last),
                      ],
                    ),
                  ),
                  IgnorePointer(
                    child: Visibility(
                      visible: !isAnimated,
                      child: SizedBox(
                        height: 200,
                        width: 200,
                        child: Image.asset(
                          'assets/images/vs.png',
                        ),
                      ),
                    ),
                  ),
                ],
              ));
  }

  Widget buildDiningSlider(int index, DiningModel dining) {
    final bool isSelected = dining == selectedDining;
    log('isSelected: $isSelected');
    final bool isTop = index == 0;
    final animation = isSelected ? inAnimation : outAnimation;

    return Flexible(
      flex: 1,
      child: Transform.translate(
        offset: Offset(0.0, animation.value * (isTop ? 1 : -1)),
        child: ImageSlider(
          imageUrls: dining.imageUrls,
          onTap: () => onDiningSelected(dining),
        ),
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
