// lib/utils/location_service.dart
import 'package:geolocator/geolocator.dart';
import 'package:kodonomad/utils/api_service.dart';

class LocationService {
  // Check and request location permissions
  static Future<bool> _checkAndRequestPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    return true;
  }

  // Get the user's current location
  static Future<Position> getCurrentLocation() async {
    try {
      await _checkAndRequestPermissions();
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Fetch nearby nomad spots using Google Places API
  static Future<List<Map<String, dynamic>>> fetchNearbySpots(double lat, double lng) async {
    const apiKey = 'YOUR_GOOGLE_API_KEY'; // Store in constants/ later
    const radius = 10000; // 10km radius
    const type = 'park|cafe|tourist_attraction'; // Types relevant to nomads

    final url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
        '?location=$lat,$lng'
        '&radius=$radius'
        '&type=$type'
        '&key=$apiKey';

    try {
      final response = await ApiService.get(url);
      final results = response['results'] as List<dynamic>;
      return results.map((place) {
        return {
          'name': place['name'],
          'lat': place['geometry']['location']['lat'],
          'lng': place['geometry']['location']['lng'],
          'distance': Geolocator.distanceBetween(
            lat,
            lng,
            place['geometry']['location']['lat'],
            place['geometry']['location']['lng'],
          ).toStringAsFixed(2) + ' meters',
        };
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch nearby spots: $e');
    }
  }
}
