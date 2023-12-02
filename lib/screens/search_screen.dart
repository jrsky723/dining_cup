import 'package:dining_cup/models/dining_model.dart';
import 'package:dining_cup/services/naver_map_api_service.dart';
import 'package:dining_cup/services/kakao_api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  NaverMapController? _controller;
  NLatLng? _currentPosition;
  String _currentAddress = '';
  final List<int> _distances = [100, 300, 500, 1000, 2000, 3000];
  int _distanceIndex = 0;
  final Set<NMarker> _markers = {};
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    NLatLng currentLatLng = NLatLng(position.latitude, position.longitude);

    // reverseGeocode() 메서드를 호출하여 위도, 경도를 주소로 변환합니다.
    String address = await NaverMapApi.reverseGeocode(currentLatLng);

    setState(() {
      _currentPosition = currentLatLng;
      _currentAddress = address;
      _markers.add(NMarker(
        id: DateTime.now().toString(),
        position: _currentPosition!,
        caption: const NOverlayCaption(
          text: '현재 위치',
        ),
      ));
      _addressController.text = _currentAddress;
    });
  }

  Future<void> _searchDinings() async {
    List<DiningModel> dinings =
        await KakaoApi.searchDinings(_addressController.text);

    setState(() {
      _markers.clear();
      for (var dining in dinings) {
        _markers.add(NMarker(
          id: dining.id,
          position: NLatLng(dining.latitude, dining.longitude),
          caption: NOverlayCaption(
            text: dining.placeName,
          ),
        ));
      }
      _controller!.addOverlayAll(_markers);
    });
  }

  void _onSliderChanged(double value) {
    setState(() {
      _distanceIndex = value.toInt();
      _updateMapZoomLevel();
    });
  }

  void _updateMapZoomLevel() {
    double newZoomLevel = calculateZoomLevel(_distances[_distanceIndex]);
    final cameraUpdate = NCameraUpdate.scrollAndZoomTo(
        target: _currentPosition!, zoom: newZoomLevel);
    _controller!.updateCamera(cameraUpdate);
  }

  // 거리에 따른 줌 레벨 계산 함수 (이 부분은 경험적으로 조정될 수 있음)
  double calculateZoomLevel(int distance) {
    // 예시: 거리에 따른 줌 레벨 계산 로직
    // 실제 줌 레벨은 프로젝트의 필요에 따라 조정되어야 함
    if (distance <= 300) return 15.0;
    if (distance <= 500) return 14.0;
    if (distance <= 1000) return 13.0;
    if (distance <= 2000) return 12.0;
    return 11.0; // 기본값
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('네이버 지도'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 200,
            child: _currentPosition == null
                ? const Center(child: CircularProgressIndicator())
                : NaverMap(
                    options: NaverMapViewOptions(
                      initialCameraPosition: NCameraPosition(
                        target: _currentPosition!,
                        zoom: 16,
                      ),
                    ),
                    onMapReady: (controller) {
                      _controller = controller;
                      _controller!.addOverlayAll(_markers);
                    },
                  ),
          ),

          // 검색창, _currentAddress를 검색창 안에 표시하고, 검색창 아래에는 검색 버튼을 표시합니다.

          // 검색창
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: _addressController, // TextField 컨트롤러 설정
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '검색',
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          // 몇 미터 이내의 음식점을 검색할지 설정하는 슬라이더 (100m, 300m, 500m, 1km, 2km, 3km)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Slider(
              value: _distanceIndex.toDouble(),
              min: 0,
              max: _distances.length.toDouble() - 1,
              divisions: _distances.length - 1,
              label: '${_distances[_distanceIndex]}m',
              onChanged: _onSliderChanged,
            ),
          ),
          ElevatedButton(
            onPressed: _searchDinings, // 검색 버튼 로직 연결
            child: const Text('검색'),
          ),
        ],
      ),
    );
  }
}
