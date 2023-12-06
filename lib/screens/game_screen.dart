import 'package:dining_cup/constants/gaps.dart';
import 'package:dining_cup/controllers/game_logic.dart';
import 'package:dining_cup/screens/winner_screen.dart';
import 'package:dining_cup/widgets/dining_text.dart';
import 'package:dining_cup/widgets/image_slider.dart';
import 'package:flutter/material.dart';
import 'package:dining_cup/models/dining_model.dart';

class GameScreen extends StatefulWidget {
  final List<DiningModel> dinings;

  const GameScreen({Key? key, required this.dinings}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late GameLogic game;
  late AnimationController animationController;
  late Animation<double> inAnimation, outAnimation;
  DiningModel? selectedDining;
  bool isAnimated = false;
  List<PageController> pageControllers = [PageController(), PageController()];

  @override
  void initState() {
    super.initState();
    game = GameLogic(dinings: widget.dinings);
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

  void resetImageSlider() {
    for (var pageController in pageControllers) {
      if (pageController.hasClients) {
        pageController.jumpToPage(0);
      }
    }
  }

  void onDiningSelected(DiningModel selectedDining) {
    this.selectedDining = selectedDining;
    if (isAnimated) return;
    isAnimated = true;
    animationController.forward().then((_) {
      setState(() {
        game.nextRoundDinings.add(selectedDining);
        game.prepareNextMatch();
        if (game.isTournamentEnd) return;
        resetImageSlider();
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
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (game.isTournamentEnd) ...[
                Icon(Icons.emoji_events_rounded, color: Colors.yellow.shade600),
                Gaps.h5,
              ],
              Flexible(
                child: Text(
                  game.isTournamentEnd
                      ? "우승: ${game.winner.placeName}"
                      : '식당 월드컵 ${game.currentRoundDiningsNumber}강 ${game.currentMatchNumber} / ${game.totalMatchesInRound}',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
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
    final bool isTop = index == 0;
    final animation = isSelected ? inAnimation : outAnimation;

    return Flexible(
      flex: 1,
      child: Transform.translate(
        offset: Offset(0.0, animation.value * (isTop ? 1 : -1)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ImageSlider(
              imageUrls: dining.imageUrls,
              onTap: () => onDiningSelected(dining),
              onPageControllerCreated: (controller) {
                pageControllers[index] = controller;
              },
            ),
            IgnorePointer(
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Center(
                  // 위치 조정
                  child: DiningText(dining: dining),
                ),
              ),
            ),
          ],
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
