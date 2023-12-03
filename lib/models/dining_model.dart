class DiningModel {
  final String id,
      addressName,
      categoryName,
      placeName,
      placeUrl,
      roadAddressName;
  final double longitude, latitude;

  DiningModel.fromJSON(Map<String, dynamic> json)
      : id = json['id'],
        addressName = json['address_name'],
        categoryName = json['category_name'].substring(6), // '음식점 > ' 제거
        placeName = json['place_name'],
        placeUrl = json['place_url'],
        roadAddressName = json['road_address_name'],
        longitude = double.parse(json['x']),
        latitude = double.parse(json['y']);
}
