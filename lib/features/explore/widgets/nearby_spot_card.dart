// lib/features/explore/widgets/nearby_spot_card.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kodonomad/utils/encryption_service.dart';

class NearbySpotCard extends StatelessWidget {
  final Map<String, dynamic> spot;

  const NearbySpotCard({required this.spot});

  @override
  Widget build(BuildContext context) {
    final location = EncryptionService.decryptLocation(spot['encrypted_location']);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(spot['name'], style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('Distance: ${spot['distance']}'),
            const SizedBox(height: 8),
            SizedBox(
              height: 150,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(location[0], location[1]),
                  zoom: 14,
                ),
                markers: {
                  Marker(
                    markerId: MarkerId(spot['name']),
                    position: LatLng(location[0], location[1]),
                  ),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
