import 'dart:convert';
import 'dart:developer';
import 'dart:math' show cos, pi;
import 'package:dining_cup/models/dining_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class KakaoApi {
  static const String _BASE_URL = 'dapi.kakao.com';
  static const String _SEARCH_KEYWORD_PATH = '/v2/local/search/keyword.json';

  static Future<Set<DiningModel>> searchDinings({
    required String query,
    required double longitude,
    required double latitude,
    required int distance,
  }) async {
    Set<DiningModel> dinings = {};

    final headers = {
      'Authorization': 'KakaoAK ${dotenv.env['KAKAO_REST_API_KEY']}',
    };
    List<String> rectangles = createRectangles(longitude, latitude, distance);

    for (var rect in rectangles) {
      int page = 1;
      bool isEnd = false;
      while (!isEnd) {
        final queryParameters = {
          'query': '$query 맛집',
          'rect': rect,
          'radius': distance.toString(),
          'x': longitude.toString(),
          'y': latitude.toString(),
          'category_group_code': 'FD6',
          'sort': 'accuracy',
          'page': page.toString(),
        };
        final uri = Uri.https(_BASE_URL, _SEARCH_KEYWORD_PATH, queryParameters);

        try {
          final response = await http.get(uri, headers: headers);
          if (response.statusCode == 200) {
            final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
            List documents = jsonResponse['documents'];
            isEnd = jsonResponse['meta']['is_end'];
            for (var document in documents) {
              dinings.add(DiningModel.fromJSON(document));
            }
            page++;
          }
        } catch (e) {
          log('searchDinings failed: $e');
          break;
        }
      }
    }
    return dinings;
  }

  static List<String> createRectangles(
      double longitude, double latitude, int radius) {
    List<String> rectangles = [];

    // 위도와 경도 당 거리 변환 계수
    double latPerMeter = 1 / 111000; // 위도 1도당 대략 111킬로미터
    double longPerMeter = 1 / (111000 * cos(latitude * pi / 180)); // 경도 변환 계수

    // distance에 따른 numRectangles 값 매핑
    Map<int, int> distanceRectangles = {
      100: 1,
      300: 2,
      500: 3,
      1000: 4,
      2000: 5,
      3000: 6,
    };

    int numRectangles = distanceRectangles[radius] ?? 1; // 기본값으로 1 설정

    // 각 사각형의 좌표 계산
    double totalHeight = 2 * radius * latPerMeter; // 전체 높이
    double rectHeight = totalHeight / numRectangles; // 각 사각형의 높이
    double topY = latitude + radius * latPerMeter; // 맨 위 사각형의 위도
    double leftX = longitude - radius * longPerMeter; // 맨 왼쪽 사각형의 경도
    double rightX = longitude + radius * longPerMeter; // 맨 오른쪽 사각형의 경도
    for (int i = 0; i < numRectangles; i++) {
      double bottomY = topY - rectHeight;
      rectangles.add("$leftX,$bottomY,$rightX,$topY");
      topY = bottomY;
    }

    return rectangles;
  }
}
