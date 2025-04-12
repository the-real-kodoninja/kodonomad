// lib/utils/location_service.dart
import 'package:geolocator/geolocator.dart';
import 'package:kodonomad/utils/api_service.dart';
import 'package:kodonomad/utils/encryption_service.dart';

class LocationService {
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

  // Get the user's current location and encrypt it
  static Future<Map<String, dynamic>> getCurrentLocation() async {
    try {
      await _checkAndRequestPermissions();
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final encryptedLocation = EncryptionService.encryptLocation(
        position.latitude,
        position.longitude,
      );
      return {
        'encrypted': encryptedLocation,
        'latitude': position.latitude, // Keep raw data for in-memory use only
        'longitude': position.longitude,
      };
    } catch (e) {
      rethrow;
    }
  }

  // Fetch nearby nomad spots using encrypted location (server-side)
  static Future<List<Map<String, dynamic>>> fetchNearbySpots(String encryptedLocation) async {
    // In a real app, this would be a Supabase function to hide the API key
    final location = EncryptionService.decryptLocation(encryptedLocation);
    const apiKey = 'YOUR_GOOGLE_API_KEY';
    const radius = 10000; // 10km radius
    const type = 'park|cafe|tourist_attraction';

    final url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
        '?location=${location[0]},${location[1]}'
        '&radius=$radius'
        '&type=$type'
        '&key=$apiKey';

    try {
      final response = await ApiService.get(url);
      final results = response['results'] as List<dynamic>;
      return results.map((place) {
        final placeLat = place['geometry']['location']['lat'];
        final placeLng = place['geometry']['location']['lng'];
        // Encrypt the place's location before returning
        final encryptedPlaceLocation = EncryptionService.encryptLocation(placeLat, placeLng);
        return {
          'name': place['name'],
          'encrypted_location': encryptedPlaceLocation,
          'distance': Geolocator.distanceBetween(
            location[0],
            location[1],
            placeLat,
            placeLng,
          ).toStringAsFixed(2) + ' meters',
        };
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch nearby spots: $e');
    }
  }
}
