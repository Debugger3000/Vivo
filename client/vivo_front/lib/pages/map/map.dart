import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vivo_front/api/Events/post_event.dart';
// import 'package:geocoding/geocoding.dart';

import 'package:vivo_front/api/google_map/google_map_wid.dart';


// STATEFUL COMPONENT
// 
class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;

  // 📍 Initial location — you can change this to your preferred coordinates
  final LatLng _initialPosition = const LatLng(44.389355, -79.690331);

  // flag variable to show post event form on button click
  // bool _showPostForm = false;

  // 
  // Marker? _marker;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }


  // Convert address to coordinates
  // Future<void> _searchAddress(String address) async {
  //   try {
  //     List<Location> locations = await locationFromAddress(address);
  //     if (locations.isNotEmpty) {
  //       final loc = locations.first;
  //       setState(() {
  //         _initialPosition = LatLng(loc.latitude, loc.longitude);
  //         _marker = Marker(
  //           markerId: MarkerId('marker_1'),
  //           position: _initialPosition,
  //         );
  //       });

  //       // Move camera
  //       mapController?.animateCamera(
  //         CameraUpdate.newLatLngZoom(_initialPosition, 15),
  //       );
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }


@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MapSample(),
          
          // // 🗺️ Base map layer
          // GoogleMap(
          //   onMapCreated: _onMapCreated,
          //   initialCameraPosition: CameraPosition(
          //     target: _initialPosition,
          //     zoom: 11.0,
          //   ),
          //   myLocationEnabled: true,
          //   myLocationButtonEnabled: true,
          //   zoomControlsEnabled: true,
          // ),

          // 🔍 Search bar overlay
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Search location...',
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          // TODO: handle live search here

                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
           // 📍 Floating button overlay
          Positioned(
            top: 175,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  isDismissible: true,  // allows tapping outside to dismiss
                  enableDrag: true,     // allows swipe down to dismiss
                  backgroundColor: Colors.transparent, // optional
                  builder: (_) => DraggableScrollableSheet(
                    initialChildSize: 0.8,
                    minChildSize: 0.4,
                    maxChildSize: 1.0,
                    
                    builder: (_, controller) => Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      child: SingleChildScrollView(
                      controller: controller,
                      child: Builder(
                        builder: (_) => PostEventForm(), // PlacesSearch only created inside PostEventForm on FAB press
                      ),
                    ),
                                      ),
                  ),
                );
              },
              backgroundColor: Colors.blue,
              child: Icon(Icons.add),
            ),
          ),
           
        ],
      
      ),
    );
  }
}
