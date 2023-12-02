import 'package:dining_cup/constants/sizes.dart';
import 'package:dining_cup/screens/home_screen.dart';
import 'package:dining_cup/services/naver_map_api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  NaverMapApi.init();
  runApp(const DiningCupApp());
}

class DiningCupApp extends StatelessWidget {
  const DiningCupApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dining Cup',
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          primaryColor: const Color(0xFF1AB394),
          appBarTheme: const AppBarTheme(
            foregroundColor: Colors.black,
            backgroundColor: Color(0xFF1AB394),
            elevation: 0,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: Sizes.size20,
              fontWeight: FontWeight.w600,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFF1AB394),
              textStyle: const TextStyle(
                fontSize: Sizes.size20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          sliderTheme: const SliderThemeData(
            activeTrackColor: Color(0xFF1AB394), // 활성 트랙 색상 (녹색 계열)
            inactiveTrackColor: Color(0xFFBDBDBD), // 비활성 트랙 색상 (회색 계열)
            thumbColor: Colors.white, // 조절 노브 색상 (황금색 계열)
            overlayColor: Color(0x29FFC107),
            trackHeight: 2.0,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.0),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0),
            valueIndicatorColor: Color(0xFF1AB394), // 말풍선 배경 색상 (보라색 계열)
            valueIndicatorTextStyle: TextStyle(
              color: Colors.white, // 말풍선 텍스트 색상
            ),
            inactiveTickMarkColor: Color(0xFFE0E0E0), // 비활성 틱 마크 색상 (연한 회색)
          )),
      home: const HomeScreen(),
    );
  }
}
