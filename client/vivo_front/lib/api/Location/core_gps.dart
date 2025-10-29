import 'package:geolocator/geolocator.dart';


// current Device location - curDeviceLocation
    // we need dedicated variable for current Device location, since location will update / poll every 5 seconds or something... 

// current screen location (B/C) - curScreenLocation


// fetch current coordinates...
// control variable - 



Future<Position> getCurrentPosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Check if location services are enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }
  // handle if location services are not enabled...

  // Check permission
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
      'Location permissions are permanently denied, cannot request.');
  }
  // handle permission problems...

  // Get current position
  return await Geolocator.getCurrentPosition(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.best,   // high precision
      distanceFilter: 0,                 // meters before next update (0 = always)
    ),
  );
}
