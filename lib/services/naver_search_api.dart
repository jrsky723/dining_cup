import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class NaverSeacrhApi {
  static const String _BASE_URL = 'openapi.naver.com';
  static const String _IMAGE_SEARCH_PATH = '/v1/search/image';

  static Future<List<String>> searchDiningImages(String query) async {
    final queryParameters = {
      'query': query,
      'display': '5',
      'sort': 'sim',
    };
    final headers = {
      'X-Naver-Client-Id': dotenv.env['NAVER_SEARCH_CLIENT_ID']!,
      'X-Naver-Client-Secret': dotenv.env['NAVER_SEARCH_CLIENT_SECRET']!,
    };
    final uri = Uri.https(_BASE_URL, _IMAGE_SEARCH_PATH, queryParameters);

    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        List results = jsonResponse['items'];

        List<String> imageUrls = [];
        if (results.isNotEmpty) {
          for (var result in results) {
            imageUrls.add(result['link']);
          }
          return imageUrls;
        } else {
          log('searchDiningImages failed: ${response.statusCode}');
        }
      }
    } catch (e) {
      log('searchDiningImages failed: $e');
    }
    return [];
  }
}
