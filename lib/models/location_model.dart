class LocationModel {
  final double latitude;
  final double longitude;
  final String? cityName;
  final String? country;

  LocationModel({
    required this.latitude,
    required this.longitude,
    this.cityName,
    this.country,
  });

  @override
  String toString() {
    if (cityName != null) {
      return country != null ? '$cityName, $country' : cityName!;
    }
    return '${latitude.toStringAsFixed(2)}, ${longitude.toStringAsFixed(2)}';
  }
}
