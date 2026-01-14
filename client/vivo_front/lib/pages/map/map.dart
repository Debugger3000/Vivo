import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vivo_front/api/Events/get_events.dart';
import 'package:vivo_front/api/Location/core_gps.dart';
import 'package:vivo_front/pages/events/CRUD/post_event.dart';
import 'package:vivo_front/api/api_service.dart';
// import 'package:geocoding/geocoding.dart';

import 'package:vivo_front/api/google_map/google_map_wid.dart';
import 'package:vivo_front/pages/events/event_window.dart';
import 'package:vivo_front/pages/map/search_bar.dart';
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
  //late LatLng? currentDeviceLocation;

  ValueNotifier<LatLng?> currentDeviceLocation = ValueNotifier<LatLng?>(null);
  // LatLng _initialPosition = const LatLng(44.389355, -79.690331);

  // event previews List
  // List<GetEventPreview> eventsList = List.empty();

  ValueNotifier<List<GetEventPreview>> eventsList = ValueNotifier<List<GetEventPreview>>([]);
  ValueNotifier<bool> isEventWindow = ValueNotifier<bool>(false);
  ValueNotifier<int> event_cycle_index = ValueNotifier<int>(0);

  // selected event



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

    final result = await getCurrentPosition();
    print("current position ");
    print(result.latitude);
    print(result.longitude);
    currentDeviceLocation.value = LatLng(result.latitude, result.longitude);
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


  // ----------------------
  // Event window functions 

  // open a solid window for the marker pop-up we click on..
  void openEventMarkerWindow(int index) {
    // re render that window...
    isEventWindow.value = true;
    // use event id to display that event ?
    if(index > -1 && index < eventsList.value.length){
      event_cycle_index.value = index;
    }
    
    print('opening event marker win...');
  }

  void cycleEventsWindow(int cycleVal) {
    int curIndex = event_cycle_index.value;
    if(cycleVal == 1){
      print("swipe upp, cycle +1");
      if(eventsList.value.length - curIndex == 1){
        //  we can increment fine
        event_cycle_index.value = 0;        
      }
      else{
        event_cycle_index.value++;
      }
    }
    else{
      print("swipe down, cycle -1");
      if(curIndex-1 < 0){
        event_cycle_index.value = eventsList.value.length-1;
      }
      else{
        event_cycle_index.value--;
      }
    }
    print("events length: ${eventsList.value.length}");
    print("current cycle index: ${event_cycle_index.value}");
  }



  void searchResults(List<GetEventPreview> eventList) {

  }

  // -----------------------------------------------------
  // location functions

  // run a stream to update map as position is changing.....
      // boilerplate for now...
  // -----------------

  // void _startLocationUpdates() async {
  //   // Make sure permissions are granted
  //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) return; // optionally show error

  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) return;
  //   }
  //   if (permission == LocationPermission.deniedForever) return;

  //   // ✅ Listen to location updates
  //   Geolocator.getPositionStream(
  //     locationSettings: const LocationSettings(
  //       accuracy: LocationAccuracy.bestForNavigation,
  //       distanceFilter: 5, // meters before update triggers
  //     ),
  //   ).listen((Position position) {
  //     currentDeviceLocation.value =
  //         LatLng(position.latitude, position.longitude);
  //   });
  // }



//   void _showEventOverlay(GetEventPreview event) {

//   _overlayEntry = OverlayEntry(
//     builder: (context) => EventOverlayContent(
//       event: event,
//       closeWindow: _hideOverlay,
//       cycleEvent: (i) =>  cycleEventsWindow(i),
//     ),
//   );

//   Overlay.of(context)!.insert(_overlayEntry!);
// }

// void _hideOverlay() {
//   _overlayEntry?.remove();
//   _overlayEntry = null;
// }




@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Stack(
        children: [

          // if (currentDeviceLocation.value == null) 
          //   const Center(child: CircularProgressIndicator())
          // else 
          // ValueListenableBuilder<List<GetEventPreview>>(
          //   valueListenable: eventsList,
          //   builder: (context, list, _) {
          //         print('🔁 Rebuilt because either events or location changed');
          //         return MapSample(
          //           mapPosition: currentDeviceLocation.value!,
          //           zoom: 11.0,
          //           myLocationEnabled: true,
          //           myLocationButtonEnabled: true,
          //           zoomControlsEnabled: true,
          //           events: list,
          //           callback: openEventMarkerWindow,
          //         );
          //   },
          // ),
          

          ValueListenableBuilder<LatLng?>(
            valueListenable: currentDeviceLocation,
            builder: (context, location, _) {
              if (location == null) {
                return const Center(child: CircularProgressIndicator());
              }

              return ValueListenableBuilder<List<GetEventPreview>>(
                valueListenable: eventsList,
                builder: (context, list, _) {
                  print('🔁 Rebuilt because either events or location changed');
                  return MapSample(
                    mapPosition: location,
                    zoom: 11.0,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    zoomControlsEnabled: true,
                    events: list,
                    callback: openEventMarkerWindow,
                  );
                },
              );
            },
          ),



          // 🔍 Search bar overlay
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: SearchBarOverlay(
              // onSelected: (query) {
              //   print('🔍 Searching for: $query');
              //   // TODO: handle live search or API call
              // },
              onSearch: searchResults,
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
              shape: CircleBorder(

                side: BorderSide(color: Colors.grey.shade200, width: 4),
              ),
              backgroundColor: Colors.grey.shade200,
              child: Icon(Icons.add,color: Colors.blue),
            ),
           
          ),

          // -----------------------------------
          // render event window
          ValueListenableBuilder(
            valueListenable: isEventWindow,
            builder : (context, val, _) {
              if(val) {
                return ValueListenableBuilder(
                  valueListenable: event_cycle_index,
                  builder : (context, index, _) {
                    print('dispalying event window i think...');
                    //return showEventWindow(context, eventsList.value[index]);
                    return EventWindow(
                      event: eventsList.value[index], 
                      closeWindow: () {
                        isEventWindow.value = false; 
                        print('basic close window through isEventWindow...');
                      },
                      cycleEvent: cycleEventsWindow,
                      
                    );
                  }
                );                
              }
              else{
                return const SizedBox.shrink(); // show nothing
              }
            }
          ),
           
        ],
      
      ),
    );
  }
}







