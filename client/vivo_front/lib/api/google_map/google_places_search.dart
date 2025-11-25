import 'package:flutter/material.dart';
import 'package:google_places_api_flutter/google_places_api_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// class PlacesSearch extends StatelessWidget {
//   final void Function(Prediction placeId, PlaceDetailsModel? latLng) onPlaceSelectedCallback;


//   const PlacesSearch({
//     super.key,
//     required this.onPlaceSelectedCallback,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: PlaceSearchField(
//           apiKey: "", // your API key
//           isLatLongRequired: true,
//           onPlaceSelected: (prediction, placeDetails) {
//             try {
//               print("latlng on places bar: ");
//               print(placeDetails);
//               onPlaceSelectedCallback(prediction, placeDetails);
          
//             } catch (e) {
//               print("ERROR on google places search bar load...");
//               print(e);
//             }
//             // pass the selected place to parent
//             // final id = prediction.place_id;
//           },
            
            
            
            
//           itemBuilder: (context, prediction) {
//             return ListTile(
//               leading: const Icon(Icons.location_on),
//               title: Text(
//                 prediction.description,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             );
//           },
//         ),
      
//     );
//   }
// }



class PlacesSearch extends StatefulWidget {
  final void Function(Prediction prediction, PlaceDetailsModel? details)
      onPlaceSelectedCallback;

  final String? address; // receives event from navigator call

  const PlacesSearch({
    super.key,
    required this.onPlaceSelectedCallback,
    this.address,
  });

  @override
  State<PlacesSearch> createState() => _PlacesSearchState();
}

class _PlacesSearchState extends State<PlacesSearch> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.address ?? '');
  }

  // @override
  // void didUpdateWidget(covariant PlacesSearch oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (widget.address != oldWidget.address && widget.address != null) {
  //     setState(() {
  //       _searchController.text = widget.address!;
  //     });
  //   }
  // }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final placesApiKey = dotenv.env['MAPS_API_KEY'] ?? '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Location',
          style: TextStyle(
          ),
        ),
        Container(
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(36),
            
            // border: Border.all(
            //   color: const Color.fromARGB(255, 218, 218, 218), // light gray
            //   width: 1.0, // thin border
            // ),
            // color: const Color.fromARGB(255, 255, 255, 255),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.black.withOpacity(0.1),
            //     blurRadius: 4,
            //     offset: const Offset(0, 2),
            //   ),
            // ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            child: PlaceSearchField(
              apiKey: placesApiKey,
              controller: _searchController,
              isLatLongRequired: true,
              
              
              
              onPlaceSelected: (prediction, placeDetails) {
                try {
                  // ✅ Populate text field with full address
                  setState(() {
                    _searchController.text = prediction.description;
                  });

                  // ✅ Trigger parent callback
                  widget.onPlaceSelectedCallback(prediction, placeDetails);
                  
                } catch (e) {
                  print("ERROR selecting place: $e");
                }
              },
              itemBuilder: (context, prediction) {
                return ListTile(
                  leading: const Icon(Icons.location_on),
                  title: Text(
                    prediction.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16)
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
