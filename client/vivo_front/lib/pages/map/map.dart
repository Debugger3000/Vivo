import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;

  // 📍 Initial location — you can change this to your preferred coordinates
  final LatLng _center = const LatLng(44.389355, -79.690331);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
        myLocationEnabled: true,           // Optional: show user location
        myLocationButtonEnabled: true,     // Optional: location button
        zoomControlsEnabled: true,         // Optional: zoom controls
      ),
    );
  }
}
