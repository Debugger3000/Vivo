import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


// ===============================
// ✅ Google Maps Sample Page
// ===============================
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vivo_front/types/event.dart';

class MapSample extends StatefulWidget {
  final LatLng mapPosition;
  final double zoom;
  final List<GetEventPreview>? markers;
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
  Set<Marker> _markersSet = {};

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
  }


  // run when new data is given to this component from its parent
  @override
  void didUpdateWidget(covariant MapSample oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.markers != oldWidget.markers) {
      _buildMarkers();
    }
  }


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
      for (int i = 0; i < widget.markers!.length; i++) {
        final event = widget.markers![i];
        final lat = event.latitude;
        final lng = event.longitude;
        markers.add(
          Marker(
            markerId: MarkerId(event.title), //title
            position: LatLng(lat, lng), //lat+lng
            infoWindow: InfoWindow(title: event.title, snippet: event.description), // title, time, address
          ),
        );
      }
    }

    print("markers ret: ");
    // print(markers);

    setState(() {
      _markersSet = markers;
    });
  }
  


  @override
  Widget build(BuildContext context) {

    // get markers
    // final mark = _buildMarkers();


    final mapWidget = GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition:CameraPosition(
        target: widget.mapPosition,
        zoom: widget.zoom,
      ),
      markers: _markersSet,
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
      body: mapWidget,
    );
  }
}
