import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../models/location_model.dart';

class LocationService {
  Future<bool> checkPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  Future<Position> getCurrentLocation() async {
    bool hasPermission = await checkPermission();

    if (!hasPermission) {
      throw Exception('Location permission denied');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ).timeout(
      const Duration(seconds: 15),
      onTimeout: () => throw Exception('Location timeout'),
    );
  }

  Future<String> getCityName(double lat, double lon) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        return placemarks[0].locality ??
            placemarks[0].subAdministrativeArea ??
            'Unknown';
      }
      return 'Unknown';
    } catch (e) {
      throw Exception('Failed to get city name');
    }
  }

  Future<LocationModel> getLocationFromCoordinates(
      double lat, double lon) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        final place = placemarks[0];
        return LocationModel(
          latitude: lat,
          longitude: lon,
          cityName: place.locality ?? place.subAdministrativeArea,
          country: place.country,
        );
      }
      return LocationModel(latitude: lat, longitude: lon);
    } catch (e) {
      return LocationModel(latitude: lat, longitude: lon);
    }
  }
}
