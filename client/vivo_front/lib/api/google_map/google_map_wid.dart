import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

  import 'dart:math';

// ===============================
// ✅ Google Maps Sample Page
// ===============================

import 'package:vivo_front/types/event.dart';

class MapSample extends StatefulWidget {
  final LatLng mapPosition;
  final double zoom;
  final List<GetEventPreview>? markers;
  final Set<Marker>? markersSet;
  final bool myLocationEnabled;
  final bool myLocationButtonEnabled;
  final bool zoomControlsEnabled;
  final Function(GoogleMapController)? onMapCreated;
  final double? height;

  const MapSample({
    super.key,
    required this.mapPosition,
    this.zoom = 12,
    this.markers,
    this.markersSet,
    this.myLocationEnabled = true,
    this.myLocationButtonEnabled = true,
    this.zoomControlsEnabled = true,
    this.onMapCreated,
    this.height,
  });

  @override
  State<MapSample> createState() => _MapSampleState();
}

class _MapSampleState extends State<MapSample> {
  
  GoogleMapController? _controller;
  Set<Marker> _markersSet = {Marker(
             markerId: MarkerId("2934930sedf"), //title
             position: LatLng(44.3448329, -79.7044902), //lat+lng
             //infoWindow: InfoWindow(title: event.title, snippet: event.description), // title, time, address
           )};

  // marker set

  // create google map instance
  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    widget.onMapCreated?.call(controller);
  }

  // run on widget creation...
  @override
  void initState() {
    super.initState();
    _buildMarkers();
    // final markers = <Marker>{};
    // Marker(
    //         markerId: MarkerId("2934930sedf"), //title
    //         position: LatLng(44.3448329, -79.7044902), //lat+lng
    //         //infoWindow: InfoWindow(title: event.title, snippet: event.description), // title, time, address
    //       );
  }


  // run when new data is given to this component from its parent
  @override
  void didUpdateWidget(covariant MapSample oldWidget) {
    print("main map; didupdateWidget ran");
    super.didUpdateWidget(oldWidget);
    // if new markers are present rebuild marker set for google map
    if (widget.markers != oldWidget.markers && widget.markers != null) {
      _buildMarkers();

      
    }
    

  }
String randomString(int length) => String.fromCharCodes(List.generate(length, (_) => Random().nextInt(1000) + 65));



  // receive enough information to display a marker..
  // plus give a preview of the card...
  // FULL EVENT DATA fetch can be called if a user clicks about 2 levels deep onto the event page...

  // receive getEventPreview type (preview data for marker / popup/preview)
  // getEventFull type (all event data for event page)


  /// Builds marker set from event positions
  void _buildMarkers() {
    final markers = <Marker>{};


    // if parent provided event positions
    if (widget.markers != null) {

      print("Events passed to google map not NULL");
      print(widget.markers);
      for (int i = 0; i < widget.markers!.length; i++) {
        final event = widget.markers![i];
        final lat = event.latitude;
        final lng = event.longitude;

        // Skip invalid coordinates
        if (lat == 0.0 && lng == 0.0) continue;
        print(lat);
        print(lng);


        markers.add(
          Marker(
            markerId: MarkerId(randomString(10)), //title
            position: LatLng(lat, lng), //lat+lng
            //infoWindow: InfoWindow(title: event.title, snippet: event.description), // title, time, address
          ),
        );
        print("added marker new");
      }
    }
    setState(() {
      _markersSet = {...markers};
    });

    print("markers ret: ");
    // print(markers);


    

    // move camera to first marker 
    if (_controller != null && _markersSet.isNotEmpty) {
      _controller!.animateCamera(
      CameraUpdate.newLatLng(_markersSet.first.position),
    );} 
  }
  


  @override
  Widget build(BuildContext context) {

    // get markers
    // final mark = _buildMarkers();
    print("Map widget rebuild triggered, markers: ${_markersSet.length}");
    print("markers set on build: $_markersSet");
    // print("'markers from parent...");
    // print(widget.markersSet);



    final mapWidget = GoogleMap(
      key: ValueKey(Random().nextInt(1000)),
      onMapCreated: _onMapCreated,
      initialCameraPosition:CameraPosition(
        target: widget.mapPosition,
        zoom: widget.zoom,
      ),
      markers:  widget.markersSet ?? {},
      myLocationEnabled: widget.myLocationEnabled,
      myLocationButtonEnabled: widget.myLocationButtonEnabled,
      zoomControlsEnabled: widget.zoomControlsEnabled,
    );

    // add markers to map if there are any


    // if height is provided, wrap in a SizedBox
    if (widget.height != null) {
      return SizedBox(height: widget.height, child: mapWidget);
    }

    // otherwise full screen map
    return Scaffold(
      appBar: null,
      body: mapWidget 
    );
  }
}
