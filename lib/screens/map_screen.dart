import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../providers/spot_provider.dart';

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final spots = ref.watch(spotProvider);
        return GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(37.7749, -122.4194),
            zoom: 10,
          ),
          markers: spots
              .map((spot) => Marker(
                    markerId: MarkerId(spot.id.toString()),
                    position: LatLng(spot.latitude, spot.longitude),
                    infoWindow: InfoWindow(title: spot.name, snippet: spot.type),
                  ))
              .toSet(),
        );
      },
    );
  }
}
