import 'dart:developer';
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
  late NLatLng _currentPosition;
  String _currentAddress = '';
  String _menu = '';
  bool _isMapLoading = true;
  bool _isMapVisible = true;
  bool _isSearching = false;
  final List<int> _distances = [100, 300, 500, 1000, 2000, 3000];
  final List<double> _zoomLevels = [15.7, 14.2, 13.5, 12.5, 11.5, 10.9];
  int _distanceIndex = 0;
  List<DiningModel> dinings = [];
  final Set<NMarker> _markers = {};
  final TextEditingController _addressController = TextEditingController();

  late Future<void> _positionFuture;

  @override
  void initState() {
    super.initState();
    _positionFuture = _determinePosition();
  }

  Future<void> _requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        log('위치 서비스 권한이 거부되었습니다.');
        return;
      }
      if (permission == LocationPermission.deniedForever) {
        // 권한이 영구적으로 거부된 경우
        log('위치 서비스 권한이 영구적으로 거부되었습니다. 설정에서 권한을 변경해야 합니다.');
        return;
      }
    }
  }

  Future<void> _determinePosition() async {
    await _requestPermission();
    try {
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      NLatLng currentLatLng = NLatLng(position.latitude, position.longitude);

      // reverseGeocode() 메서드를 호출하여 위도, 경도를 주소로 변환합니다.
      String address = await NaverMapApi.reverseGeocode(currentLatLng);

      setState(() {
        _currentPosition = currentLatLng;
        _currentAddress = address;
        _addressController.text = _currentAddress;
      });
    } catch (e) {
      log('위치 서비스를 사용할 수 없습니다: $e');
    }
  }

  Future<void> searchDinings() async {
    setState(() {
      _isSearching = true;
    });

    dinings = await KakaoApi.searchDinings(
      query: _menu,
      longitude: _currentPosition.longitude,
      latitude: _currentPosition.latitude,
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
      addCircleOverlay();
    });

    setState(() {
      _isSearching = false;
    });
  }

  void onMapReady(NaverMapController controller) async {
    setState(() {
      _isMapLoading = false;
    });
    _controller = controller;
    final locationOverlay = await _controller!.getLocationOverlay();
    locationOverlay.setIsVisible(true);
    addCircleOverlay();
  }

  void onSearchIconPressed() async {
    NLatLng? latLng =
        await NaverMapApi.geocode(_currentAddress, _currentPosition);
    setState(() {
      if (latLng == null) {
        _addressController.clear();
        _addressController.text = '검색 결과가 없습니다.';
      } else {
        _currentPosition = latLng;
      }
      updateMapZoomLevel();
    });
  }

  void onSliderChanged(double value) {
    setState(() {
      _distanceIndex = value.toInt();
      if (_isMapLoading) return;
      updateMapZoomLevel();
    });
  }

  void addCircleOverlay() {
    _controller!.addOverlay(NCircleOverlay(
      id: 'circle',
      center: _currentPosition,
      radius: _distances[_distanceIndex].toDouble(),
      color: const Color.fromRGBO(255, 193, 7, 0.3),
      outlineColor: const Color.fromRGBO(255, 193, 7, 0.7),
      outlineWidth: 2,
    ));
  }

  void updateMapZoomLevel() {
    double newZoomLevel = _zoomLevels[_distanceIndex];
    final cameraUpdate = NCameraUpdate.scrollAndZoomTo(
        target: _currentPosition, zoom: newZoomLevel);
    _controller!.updateCamera(cameraUpdate);
    // 원의 반경을 표시하기 위해 원을 그리는 로직을 추가합니다.
    addCircleOverlay();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isMapLoading && !_isSearching,
      onPopInvoked: (didPop) => {
        if (didPop)
          {
            setState(() {
              _isMapVisible = false;
            })
          }
      },
      child: Scaffold(
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
              onPressed: onSearchIconPressed,
            ),
          ],
        ),
        body: AbsorbPointer(
          absorbing: _isMapLoading,
          child: Column(
            children: [
              Visibility(
                  visible: _isMapVisible,
                  child: Flexible(
                    child: SizedBox(
                      height: 200,
                      child: FutureBuilder(
                        future: _positionFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return NaverMap(
                              options: NaverMapViewOptions(
                                initialCameraPosition: NCameraPosition(
                                  target: _currentPosition,
                                  zoom: _zoomLevels[_distanceIndex],
                                ),
                              ),
                              onMapReady: onMapReady,
                            );
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        },
                      ),
                    ),
                  )),
              // 주소 검색창
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12.0),
                child: Column(
                  children: [
                    Slider(
                      value: _distanceIndex.toDouble(),
                      min: 0,
                      max: _distances.length.toDouble() - 1,
                      divisions: _distances.length - 1,
                      label: '${_distances[_distanceIndex]}m',
                      onChanged: onSliderChanged,
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
                    Text('식당 갯수: ${_markers.length}'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (!_isMapLoading && !_isSearching) {
                              searchDinings();
                            }
                          }, // 검색 버튼 로직 연결
                          child: const Text('식당 검색'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (!_isMapLoading && !_isSearching) {
                              Navigator.pop(context, dinings);
                            }
                          },
                          child: const Text('탐색 완료'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // 몇 미터 이내의 음식점을 검색할지 설정하는 슬라이더 (100m, 300m, 500m, 1km, 2km, 3km)
            ],
          ),
        ),
      ),
    );
  }
}
