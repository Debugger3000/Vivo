
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerBuilder {
  static Marker build({
    required double lat,
    required double lng,
    String? title,
    String? description,
  }) {
    return Marker(
      markerId: MarkerId('${lat}_${lng}'),
      position: LatLng(lat, lng),
      infoWindow: InfoWindow(
        title: title ?? 'Your New Event!',
        snippet: description ?? 'Make it a time!',
      ),
    );
  }
}
