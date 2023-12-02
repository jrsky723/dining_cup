import 'dart:convert';
import 'dart:developer';

import 'package:dining_cup/models/dining_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class KakaoApi {
  static const String _BASE_URL = 'dapi.kakao.com';
  static const String _SEARCH_KEYWORD_PATH = '/v2/local/search/keyword.json';

  static Future<List<DiningModel>> searchDinings(
    String query,
  ) async {
    List<DiningModel> dinings = [];

    final headers = {
      'Authorization': 'KakaoAK ${dotenv.env['KAKAO_REST_API_KEY']}',
    };

    final queryParameters = {
      'query': query,
      'category_group_code': 'FD6',
    };
    final uri = Uri.https(_BASE_URL, _SEARCH_KEYWORD_PATH, queryParameters);

    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        List documents = jsonResponse['documents'];
        for (var document in documents) {
          dinings.add(DiningModel.fromJSON(document));
        }
      }
    } catch (e) {
      log('searchDinings failed: $e');
    }

    return dinings;
  }
}
