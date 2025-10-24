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

class _MapPageState extends State<MapPage> with WidgetsBindingObserver {
  final ApiService api = ApiService(); 
  // 📍 Initial location — you can change this to your preferred coordinates
  final LatLng _initialPosition = const LatLng(44.389355, -79.690331);
  // event previews List
  // List<GetEventPreview> eventsList = List.empty();

  ValueNotifier<List<GetEventPreview>> eventsList = ValueNotifier<List<GetEventPreview>>([]);


// Update this widget + its ancestors
// super useful...
// -----------
// our reactive value holder
//  final ValueNotifier<int> counter = ValueNotifier<int>(0);
// //  ValueListenableBuilder<int>(
//           valueListenable: counter,
//           builder: (context, value, _) {
//             print('Only this builder rebuilds');
//             return Text('Count: $value');
//           },
//         ),

// -------------------------------

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    print('init state in map.dart');
    _loadEvents();
  }

  // ---------------------------

  Future<void> _loadEvents() async {
    final events = await getEvents(api);
    
      print("set state for events list...");
    eventsList.value = events;
    
  }

  // watch life cycle state of this page
  // 
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("App state changed: $state");
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
          ValueListenableBuilder(
            valueListenable: eventsList, 
            builder: (context, list, _) {
              
              print('🔁 List rebuilt heheheheheheheheh');
              return MapSample(
                mapPosition: _initialPosition,  
                zoom: 11.0,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: true,
                events: list,
              );
            }
          ),
          // create google map instance from widget
          // MapSample(
          //   mapPosition: _initialPosition,  
          //   zoom: 11.0,
          //   myLocationEnabled: true,
          //   myLocationButtonEnabled: true,
          //   zoomControlsEnabled: true,
          //   events: eventsList.value,
          // ),

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
          // + | add event button
          Positioned(
            top: 175,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/post_event');
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



