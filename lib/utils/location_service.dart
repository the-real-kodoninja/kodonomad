// lib/utils/location_service.dart
import 'package:geolocator/geolocator.dart';
import 'package:kodonomad/utils/api_service.dart';
import 'package:kodonomad/utils/encryption_service.dart';

class LocationService {
  static Future<bool> _checkAndRequestPermissions() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw LocationException('Location services are disabled. Please enable them in your device settings.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw LocationException('Location permissions are denied. Please grant permission to continue.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw LocationException('Location permissions are permanently denied. Please enable them in your app settings.');
      }

      return true;
    } catch (e) {
      throw LocationException('Failed to check or request permissions: $e');
    }
  }

  static Future<Map<String, dynamic>> getCurrentLocation() async {
    try {
      await _checkAndRequestPermissions();
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        throw LocationException('Failed to get location: Request timed out.');
      });
      final encryptedLocation = EncryptionService.encryptLocation(
        position.latitude,
        position.longitude,
      );
      return {
        'encrypted': encryptedLocation,
        'latitude': position.latitude,
        'longitude': position.longitude,
      };
    } catch (e) {
      throw LocationException('Failed to get current location: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchNearbySpots(String encryptedLocation) async {
    try {
      final location = EncryptionService.decryptLocation(encryptedLocation);
      const apiKey = 'YOUR_GOOGLE_API_KEY';
      const radius = 10000;
      const type = 'park|cafe|tourist_attraction';

      final url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
          '?location=${location[0]},${location[1]}'
          '&radius=$radius'
          '&type=$type'
          '&key=$apiKey';

      final response = await ApiService.get(url).timeout(const Duration(seconds: 10), onTimeout: () {
        throw LocationException('Failed to fetch nearby spots: Request timed out.');
      });
      final results = response['results'] as List<dynamic>;
      return results.map((place) {
        final placeLat = place['geometry']['location']['lat'];
        final placeLng = place['geometry']['location']['lng'];
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
      throw LocationException('Failed to fetch nearby spots: $e');
    }
  }
}

class LocationException implements Exception {
  final String message;
  LocationException(this.message);

  @override
  String toString() => message;
}
