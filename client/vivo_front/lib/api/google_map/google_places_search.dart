import 'package:flutter/material.dart';
import 'package:google_places_api_flutter/google_places_api_flutter.dart';

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
//           apiKey: "AIzaSyC_o3tXMGvFS0mbvg_pTJdPwzj52uCL02w", // your API key
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

  const PlacesSearch({
    super.key,
    required this.onPlaceSelectedCallback,
  });

  @override
  State<PlacesSearch> createState() => _PlacesSearchState();
}

class _PlacesSearchState extends State<PlacesSearch> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            color: const Color.fromARGB(255, 255, 255, 255),
            // boxShadow: [
            //   BoxShadow(
            //     // color: Colors.black.withOpacity(0.1),
            //     // blurRadius: 4,
            //     offset: const Offset(0, 2),
            //   ),
            // ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: PlaceSearchField(
              apiKey: "AIzaSyC_o3tXMGvFS0mbvg_pTJdPwzj52uCL02w",
              controller: _searchController, // 👈 add controller
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
