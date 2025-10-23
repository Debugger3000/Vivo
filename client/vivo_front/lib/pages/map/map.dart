import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vivo_front/api/Events/get_events.dart';
import 'package:vivo_front/pages/events/CRUD/post_event.dart';
import 'package:vivo_front/api/api_service.dart';
// import 'package:geocoding/geocoding.dart';

import 'package:vivo_front/api/google_map/google_map_wid.dart';
import 'package:vivo_front/types/event.dart';


// Map Page Sub Page Navigator 
// Allows bottom tab to persist, and

class MapTab extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const MapTab({super.key, required this.navigatorKey});

  

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: '/map',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;

        switch (settings.name) {
          case '/map':
            builder = (context) => MapPage(); // Your main map UI
            break;
          case '/post_event':
            builder = (context) => PostEventForm(); // Subpage to push
            break;
          default:
            builder = (context) => MapPage();
        }

        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}
// -------------------------


// STATEFUL COMPONENT
// 
class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final ApiService api = ApiService(); 
  // 📍 Initial location — you can change this to your preferred coordinates
  final LatLng _initialPosition = const LatLng(44.389355, -79.690331);
  // event previews List
  List<GetEventPreview> eventsList = List.empty();

// -------------------------------

  @override
  void initState() {
    super.initState();
    print('init state in map.dart');
    _loadEvents();
  }

  // ---------------------------

  Future<void> _loadEvents() async {
    final events = await getEvents(api);
    setState(() {
      print("set state for events list...");
      eventsList = events;
    });
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
      appBar: null,
      body: Stack(
        children: [
          // create google map instance from widget
          MapSample(
            mapPosition: _initialPosition,  
            zoom: 11.0,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            events: eventsList,
          ),

          // 🔍 Search bar overlay
          Positioned(
            top: 10,
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
                Navigator.of(context).pushNamed('/post_event');

                // showModalBottomSheet(
                //   context: context,
                //   isScrollControlled: true,
                //   isDismissible: true,  // allows tapping outside to dismiss
                //   enableDrag: true,     // allows swipe down to dismiss
                //   backgroundColor: Colors.transparent, // optional
                //   builder: (_) => DraggableScrollableSheet(
                //     initialChildSize: 0.8,
                //     minChildSize: 0.4,
                //     maxChildSize: 1.0,
                    
                //     builder: (_, controller) => Container(
                //       decoration: const BoxDecoration(
                //         color: Colors.white,
                //         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                //       ),
                //       child: SingleChildScrollView(
                //       controller: controller,
                //       child: Builder(
                //         builder: (_) => PostEventForm(), // PlacesSearch only created inside PostEventForm on FAB press
                //       ),
                //     ),
                //                       ),
                //   ),
                // );
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



