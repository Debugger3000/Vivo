
import 'package:google_maps_flutter/google_maps_flutter.dart';


// Just build a marker for the google map - Set<Marker>
class MarkerBuilderWithWindow {
  static Marker build({
    required int index,
    required double lat,
    required double lng,
    required void Function(int) onTap,
    String? title,
    String? description,
  }) {
    return Marker(
      markerId: MarkerId('${lat}_${lng}'),
      position: LatLng(lat, lng),
      //onTap: () {
       
      //},
      infoWindow: InfoWindow(
        // on tap for info window...
        onTap: () {
          onTap(index);
          print("YOU PRESSED ON EVENT MARKER infowindow");
        },
        title: title ?? 'Your New Event!',
        snippet: description ?? 'Make it a time!',
      ),
    );
  }
}

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
      //onTap: () {
       
      //},
      infoWindow: InfoWindow(
        // on tap for info window...
        onTap: () {
          print("YOU PRESSED ON EVENT MARKER infowindow");
        },
        title: title ?? 'Your New Event!',
        snippet: description ?? 'Make it a time!',
      ),
    );
  }
}
