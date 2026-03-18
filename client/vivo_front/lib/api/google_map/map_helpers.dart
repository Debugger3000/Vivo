
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vivo_front/utility/user_functions.dart';


// Just build a marker for the google map - Set<Marker>
class MarkerBuilderWithWindow {
  static Marker build({
    required int index,
    required double lat,
    required double lng,
    required void Function(int) onTap,
    String? title,
    String? description,
    String? startTime,
    String? endTime,
  }) {

    final start = formatEventTime(startTime);
    final end = formatEventTime(endTime);
    final timeDisplay = "$start - $end";

    return Marker(
      markerId: MarkerId('${lat}_$lng'),
      position: LatLng(lat, lng),
      infoWindow: InfoWindow(
        // onTap: () {
        //   onTap(index);
        //   print("YOU PRESSED ON EVENT MARKER infowindow");
        // },
        title: title ?? 'Event Title',
        // description with time
        snippet: timeDisplay,
        
      ),
    );
  }
}

// marker builder for Edit / Create events...
class MarkerBuilder {
  static Marker build({
    required double lat,
    required double lng,
    String? title,
    String? description,
  }) {
    return Marker(
      markerId: MarkerId('${lat}_$lng'),
      position: LatLng(lat, lng),
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
