import 'package:dining_cup/constants/gaps.dart';
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
  String _menu = '';
  final List<int> _distances = [100, 300, 500, 1000, 2000, 3000];
  final List<double> _zoomLevels = [15.7, 14.2, 13.5, 12.5, 11.5, 10.9];
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
      _addressController.text = _currentAddress;
    });
  }

  Future<void> _searchDinings() async {
    List<DiningModel> dinings = await KakaoApi.searchDinings(
      query: _menu,
      longitude: _currentPosition!.longitude,
      latitude: _currentPosition!.latitude,
      distance: _distances[_distanceIndex],
    );

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
      _controller!.clearOverlays();
      _controller!.addOverlayAll(_markers);
      _addCircleOverlay();
    });
  }

  void _onSearchIconPressed() async {
    NLatLng? latLng =
        await NaverMapApi.geocode(_currentAddress, _currentPosition!);
    setState(() {
      if (latLng == null) {
        _addressController.clear();
        _addressController.text = '검색 결과가 없습니다.';
      } else {
        _currentPosition = latLng;
      }
      _updateMapZoomLevel();
    });
  }

  void _onSliderChanged(double value) {
    setState(() {
      _distanceIndex = value.toInt();
      _updateMapZoomLevel();
    });
  }

  void _addCircleOverlay() {
    _controller!.addOverlay(NCircleOverlay(
      id: 'circle',
      center: _currentPosition!,
      radius: _distances[_distanceIndex].toDouble(),
      color: const Color.fromRGBO(255, 193, 7, 0.3),
      outlineColor: const Color.fromRGBO(255, 193, 7, 0.7),
      outlineWidth: 2,
    ));
  }

  void _updateMapZoomLevel() {
    double newZoomLevel = _zoomLevels[_distanceIndex];
    final cameraUpdate = NCameraUpdate.scrollAndZoomTo(
        target: _currentPosition!, zoom: newZoomLevel);
    _controller!.updateCamera(cameraUpdate);
    // 원의 반경을 표시하기 위해 원을 그리는 로직을 추가합니다.
    _addCircleOverlay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1.0,
        title: TextField(
          controller: _addressController,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: '주소를 검색하세요',
          ),
          onChanged: (value) => setState(() {
            _currentAddress = value;
          }),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _addressController.clear();
              setState(() {
                _currentAddress = '';
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _onSearchIconPressed,
          ),
        ],
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
                        zoom: _zoomLevels[_distanceIndex],
                      ),
                    ),
                    onMapReady: (controller) async {
                      _controller = controller;
                      final locationOverlay =
                          await _controller!.getLocationOverlay();
                      locationOverlay.setIsVisible(true);
                      _addCircleOverlay();
                    },
                  ),
          ),
          // 주소 검색창
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12.0),
            child: Column(
              children: [
                Slider(
                  value: _distanceIndex.toDouble(),
                  min: 0,
                  max: _distances.length.toDouble() - 1,
                  divisions: _distances.length - 1,
                  label: '${_distances[_distanceIndex]}m',
                  onChanged: _onSliderChanged,
                ),
                Gaps.v20,
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '먹고 싶은 메뉴를 검색하세요',
                    suffixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    _menu = value;
                  },
                ),
              ],
            ),
          ), // 몇 미터 이내의 음식점을 검색할지 설정하는 슬라이더 (100m, 300m, 500m, 1km, 2km, 3km)
          ElevatedButton(
            onPressed: _searchDinings, // 검색 버튼 로직 연결
            child: const Text('식당 검색'),
          ),
        ],
      ),
    );
  }
}
