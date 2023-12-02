import 'dart:developer';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class NaverMapApi {
  static const String _BASE_URL = 'naveropenapi.apigw.ntruss.com';
  static const String _REVERSE_GEOCODE_PATH = '/map-reversegeocode/v2/gc';
  static const String _GEOCODE_PATH = '/map-geocode/v2/geocode';

  static Future<void> init() async {
    await NaverMapSdk.instance.initialize(
      clientId: dotenv.env['NAVER_MAP_CLIENT_ID']!,
      onAuthFailed: (error) {
        log('NaverMapSdk init failed: $error');
      },
    );
  }

  static Future<String> reverseGeocode(NLatLng latLng) async {
    final queryParameters = {
      'coords': '${latLng.longitude},${latLng.latitude}',
      'sourcecrs': 'epsg:4326',
      'orders': 'addr,admcode,roadaddr',
      'output': 'json',
    };
    final headers = {
      'X-NCP-APIGW-API-KEY-ID': dotenv.env['NAVER_MAP_CLIENT_ID']!,
      'X-NCP-APIGW-API-KEY': dotenv.env['NAVER_MAP_CLIENT_SECRET']!,
    };
    final uri = Uri.https(_BASE_URL, _REVERSE_GEOCODE_PATH, queryParameters);

    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        List results = jsonResponse['results'];

        String address = '';
        if (results.isNotEmpty) {
          var addrResult = results.firstWhere(
            (result) => result['name'] == 'addr',
            orElse: () => null,
          );
          if (addrResult != null) {
            var region = addrResult['region'];
            var area1 = region['area1']['name']; // 도, 시
            var area2 = region['area2']['name']; // 구, 군, 면
            var area3 = region['area3']['name']; // 동, 읍
            address = '$area1 $area2 $area3';
            return address;
          }
        } else {
          log('reverseGeocode failed: ${response.statusCode}');
        }
      }
    } catch (e) {
      log('reverseGeocode failed: $e');
    }
    return '';
  }

  static Future<NLatLng?> geocode(String query, NLatLng latLng) async {
    final queryParameters = {
      'query': query,
      'coordinate': '${latLng.longitude},${latLng.latitude}',
    };
    final headers = {
      'X-NCP-APIGW-API-KEY-ID': dotenv.env['NAVER_MAP_CLIENT_ID']!,
      'X-NCP-APIGW-API-KEY': dotenv.env['NAVER_MAP_CLIENT_SECRET']!,
    };
    final uri = Uri.https(_BASE_URL, _GEOCODE_PATH, queryParameters);

    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        List addresses = jsonResponse['addresses'];

        if (addresses.isNotEmpty) {
          var address = addresses.first;
          var x = double.parse(address['x']);
          var y = double.parse(address['y']);
          return NLatLng(y, x);
        } else {
          log('geocode failed: ${response.statusCode}');
        }
      }
    } catch (e) {
      log('geocode failed: $e');
    }
    return null;
  }
}
