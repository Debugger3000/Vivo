import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vivo_front/api/google_map/map_helpers.dart';

  import 'dart:math';

// ===============================
// ✅ Google Maps Sample Page
// ===============================

import 'package:vivo_front/types/event.dart';

class MapSample extends StatefulWidget {
  final LatLng mapPosition;
  final double zoom;
  final List<GetEventPreview>? events;
  final Set<Marker>? markersSet;
  final bool myLocationEnabled;
  final bool myLocationButtonEnabled;
  final bool zoomControlsEnabled;
  final Function(GoogleMapController)? onMapCreated;
  final double? height;
  final void Function(int)? callback;

  const MapSample({
    super.key,
    required this.mapPosition,
    this.zoom = 12,
    this.events,
    this.markersSet,
    this.myLocationEnabled = true,
    this.myLocationButtonEnabled = true,
    this.zoomControlsEnabled = true,
    this.onMapCreated,
    this.height,
    this.callback,
  });

  @override
  State<MapSample> createState() => _MapSampleState();
}

class _MapSampleState extends State<MapSample> {
  
  GoogleMapController? _controller;
  Set<Marker> _markersSet = {};   // marker set

  String randomString(int length) => String.fromCharCodes(List.generate(length, (_) => Random().nextInt(1000) + 65));

// ---------------------------------

  // run on widget creation...
  @override
  void initState() {
    super.initState();
    // _buildMarkers();
  }


  // run when new data is given to this component from its parent
  @override
  void didUpdateWidget(covariant MapSample oldWidget) {
    print("main map; didupdateWidget ran");
    super.didUpdateWidget(oldWidget);
    // if new markers are present rebuild marker set for google map
    if (widget.events != oldWidget.events && widget.events != null) {
      _buildMarkers();
    }
    else if(widget.markersSet != oldWidget.markersSet && widget.markersSet != null){
      setState(() {
        print("set new marker set heheheheheheheheheheheheheheh");
        _markersSet = widget.markersSet!;
      });
    }
  }

  // ------------------------------------

  // create google map instance
  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    widget.onMapCreated?.call(controller);
  }


  /// Builds marker set from event positions
  void _buildMarkers() {
    final markers = <Marker>{};
    // if parent provided event positions
    if (widget.events != null) {
      print("Events passed to google map not NULL");
      for (int i = 0; i < widget.events!.length; i++) {
        final event = widget.events![i];
        // Skip invalid coordinates
        if (event.longitude == 0.0 || event.latitude == 0.0) continue;
        final marker = MarkerBuilderWithWindow.build(index: i, lat: event.latitude, lng: event.longitude, title: event.title, description: event.description, onTap: widget.callback! );
        
        // add a marker to the new set
        markers.add(marker);
      }
    }
    setState(() {
      _markersSet = markers;
    });

    // move camera to first marker 
    if (_controller != null && _markersSet.isNotEmpty) {
      _controller!.animateCamera(
      CameraUpdate.newLatLng(_markersSet.first.position),
    );} 
  }

// --------------------------------------------------
// Build
  @override
  Widget build(BuildContext context) {
    print("Map widget rebuild triggered, markers: ${_markersSet.length}");
    
    final mapWidget = GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition:CameraPosition(
        target: widget.mapPosition,
        zoom: widget.zoom,
      ),
      markers:  _markersSet,
      myLocationEnabled: widget.myLocationEnabled,
      myLocationButtonEnabled: widget.myLocationButtonEnabled,
      zoomControlsEnabled: widget.zoomControlsEnabled,
    );

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
