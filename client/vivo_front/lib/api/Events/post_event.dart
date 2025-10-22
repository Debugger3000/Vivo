import 'package:flutter/material.dart';
// import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
import 'package:vivo_front/api/api_service.dart';
import 'package:vivo_front/com_ui_widgets/padding.dart';
import 'package:vivo_front/com_ui_widgets/subpage_header.dart';
// import 'package:vivo_front/types/event.dart';
import 'package:vivo_front/utility/user_functions.dart';
import 'package:vivo_front/types/categories.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geocoding/geocoding.dart';

import 'package:vivo_front/api/google_map/google_places_search.dart';
import 'package:google_places_api_flutter/google_places_api_flutter.dart';


class PostEventForm extends StatefulWidget {
  // accept callback for maps.dart - google maps instance
  const PostEventForm({super.key});

  @override
  State<PostEventForm> createState() => PostEventFormState();
}

class PostEventFormState extends State<PostEventForm> {
  final _formKey = GlobalKey<FormState>();
  final ApiService api = ApiService(); 
  late GoogleMapController _mapController; // Create google map controller for google map instance in POST event form

  // 📍 Initial location — you can change this to your preferred coordinates
  LatLng _mapPosition = const LatLng(44.389355, -79.690331);
  // marker for map to show single location given by location form field 
  Marker? _marker;



  // on mount run function
  // runs on class initialization
  @override
  void initState() {
    super.initState();
    print('init in post eventer...........................');
    // developer.log("Post event form has ran hehe", name: 'vivo-loggy', level: 0);
    getCategories();
  }

  // @override
  // void didChangeDependencies()  {
  //   super.didChangeDependencies();
  // _fetchCategories();
  // }

// Future<void> _fetchCategories() async {
//   await getCategories();
// }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    _categoriesController.dispose();
    _dateController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

// ----------------------------------
// google places autocomplete
  double curLat = 44.389355;
  double curLng = -79.690331;
  String curAddress = "18 Claudio Crescent";

  // Convert address to LatLng
  Future<void> _goToAddress(Prediction placeId, PlaceDetailsModel? placeDetails) async {
    try {

      if(placeDetails != null && placeDetails.result.geometry != null){
        final lat = placeDetails.result.geometry!.location.lat;
        final lng = placeDetails.result.geometry!.location.lng;

        final newPos = LatLng(lat, lng); // create latLng object for selected coordinates...
        print("lat: ");
        print(lat);
        print("lang: ");
        print(lng);
        

        curLat = lat; // set lat 
        curLng = lng; // set lng
        curAddress = placeDetails.result.formatted_address!;
        print(placeDetails.result.formatted_address!);
      


        setState(() {
          _mapPosition = newPos;
          print("setting new map position / marker for POST-EVENT-FORM MAP");
          _marker = Marker(
            markerId: const MarkerId('selected_address HEHE'),
            position: newPos,
          );
        });

        _mapController.animateCamera(
          CameraUpdate.newLatLngZoom(newPos, 15),
        );

      }

      
      
    } catch (e) {
      print('Error geocoding address: $e');
    }
  }


  // Form controllers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagsController = TextEditingController();
  final _categoriesController = TextEditingController();
  final _dateController = TextEditingController();
  final _locationController = TextEditingController();


  // variable to hold incoming categories
  // user will choose from these in a dropdown, to populate his chosen category array
  List<String> grabbedCategories = List.empty();
  List<String> selectedCategories = [];

  // tags
  // user sort of Hashtags.. They input via a field, and we see them as little buttons like category dropdown
  List<String> selectedTags = [];

  // fetch categories from DB
  Future<void> getCategories() async {
    try {
      print('calling get on categories...');
      final categories = await api.requestList<String>(
        endpoint: '/api/categories',
        parser: (item) => item as String,
      );

      // print("printer;categories returned: $categories");
      // developer.log("GET returned response: $categories", name:'vivo-loggy', level: 0);
      print("returned GET data: $categories");

      if(categories != null) {
         // IMPORTANT: setState() should be used to update UI / core to flutter/dart lifecycle...
        setState(() {
          grabbedCategories = categories;
        });
      }

     
    } catch (e) {
      print('error: $e');
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  // add tag helper function
  void _addTag() {
    final tag = _tagsController.text.trim();
    if (tag.isNotEmpty &&
        !selectedTags.contains(tag) &&
        selectedTags.length < 3) {
      setState(() {
        selectedTags.add(tag);
        _tagsController.clear();
      });
    }
  }

  // call get Categories to populate dropdown for categories

  bool _isSubmitting = false;
  String _resultMessage = '';


// ----------------------
// SUBMIT EVENT
  Future<void> _submitEvent() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _resultMessage = '';
    });

    // make sure categories are selected... at least one
    if (selectedCategories.isEmpty) {
      setState(() {
        _isSubmitting = false;
        _resultMessage = 'Please select at least one category for your event!';
      });
      return;
    }

    try {
      // get user id
      final userId = await getCurrentUserId();

      print('Current user ID: $userId');
      print({
          'userId': userId,
          'title': _titleController.text,
          'description': _descriptionController.text,
          'tags': selectedTags,
          'categories': selectedCategories,
          'date': _dateController.text,
          'address': curAddress, //needs to take physical address (77 dancer rd, toronto, On, Canada)
          'lat': curLat,
          'lng': curLng,
        });

      final newEvent = await api.request(
        endpoint: '/api/events',
        method: 'POST',
        body: {
          'userId': userId,
          'title': _titleController.text,
          'description': _descriptionController.text,
          'tags': selectedTags,
          'categories': selectedCategories,
          'date': _dateController.text,
          'address': curAddress, //needs to take physical address (77 dancer rd, toronto, On, Canada)
          'lat': curLat,
          'lng': curLng,
        },
      );

      print(newEvent.message);
      print("post event after req...");

      setState(() {
        _resultMessage = '✅ Event created with ID: $newEvent';
      });

      // print(newEvent);

      // Clear form
      selectedCategories.clear();
      selectedTags.clear();
      _titleController.clear();
      _descriptionController.clear();
      _tagsController.clear();
      _categoriesController.clear();
      _dateController.clear();
      // _locationController.clear();
      curLat = 44.389355;
      curLng = -79.690331;
      curAddress = "18 Claudio Crescent";
    } catch (e) {
      setState(() {
        _resultMessage = '❌ submit event Error: $e';
      });
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SubPageHeader(title: 'Create Event'),
      body: SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child:  Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
          children: [
            BasicTextField( controller: _titleController,
              label: 'Title',
              validator: (v) => v == null || v.isEmpty ? 'Enter title' : null
            ),
            // TextFormField(
            //   controller: _titleController,
            //   decoration: const InputDecoration(labelText: 'Title'),
            //   validator: (v) => v == null || v.isEmpty ? 'Enter title' : null,
            // ),
            // TextFormField(
            //   controller: _descriptionController,
            //   decoration: const InputDecoration(labelText: 'Description'),
            //   validator: (v) =>
            //       v == null || v.isEmpty ? 'Enter description' : null,
            // ),
            BasicTextField( controller: _descriptionController,
              label: 'Description',
              maxLines: 5,
              maxLength: 250,
              keyboardType: TextInputType.multiline,
              validator: (v) => v == null || v.isEmpty ? 'Description' : null
            ),

            // Replace your TextFormField for date with this:
            // TextFormField(
            //   controller: _dateController,
            //   readOnly: true, // prevents manual typing
            //   decoration: const InputDecoration(
            //     labelText: 'Date & Time',
            //     suffixIcon: Icon(Icons.calendar_today),
            //   ),
            //   onTap: () async {
            //     // Pick the date first
            //     final DateTime? pickedDate = await showDatePicker(
            //       context: context,
            //       initialDate: DateTime.now(),
            //       firstDate: DateTime(2000),
            //       lastDate: DateTime(2100),
            //     );

            //     if (pickedDate == null) return; // user canceled

            //     // Pick the time
            //     final TimeOfDay? pickedTime = await showTimePicker(
            //       context: context,
            //       initialTime: TimeOfDay.now(),
            //     );

            //     if (pickedTime == null) return; // user canceled

            //     // Combine date + time
            //     final DateTime finalDateTime = DateTime(
            //       pickedDate.year,
            //       pickedDate.month,
            //       pickedDate.day,
            //       pickedTime.hour,
            //       pickedTime.minute,
            //     );

            //     // Update the controller
            //     setState(() {
            //       _dateController.text =
            //           "${finalDateTime.year.toString().padLeft(4, '0')}-"
            //           "${finalDateTime.month.toString().padLeft(2, '0')}-"
            //           "${finalDateTime.day.toString().padLeft(2, '0')} "
            //           "${finalDateTime.hour.toString().padLeft(2, '0')}:"
            //           "${finalDateTime.minute.toString().padLeft(2, '0')}";
            //     });
            //   },
            // ),

            BasicTextField(
              controller: _dateController,
              label: 'Date',
              suffixIcon: Icon(Icons.calendar_today),
              readOnly: true, // prevents manual typing
              onTap: () async {
                // Pick the date first
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );

                if (pickedDate == null) return; // user canceled

                // Pick the time
                final TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                if (pickedTime == null) return; // user canceled

                // Combine date + time
                final DateTime finalDateTime = DateTime(
                  pickedDate.year,
                  pickedDate.month,
                  pickedDate.day,
                  pickedTime.hour,
                  pickedTime.minute,
                );

                // Update the controller
                setState(() {
                  _dateController.text =
                      "${finalDateTime.year.toString().padLeft(4, '0')}-"
                      "${finalDateTime.month.toString().padLeft(2, '0')}-"
                      "${finalDateTime.day.toString().padLeft(2, '0')} "
                      "${finalDateTime.hour.toString().padLeft(2, '0')}:"
                      "${finalDateTime.minute.toString().padLeft(2, '0')}";
                });
              },
            ),

            PlacesSearch(onPlaceSelectedCallback: _goToAddress),



            // TextFormField(
            //   controller: _locationController,
            //   decoration: const InputDecoration(labelText: 'Location'),
            //   validator: (v) =>
            //       v == null || v.isEmpty ? 'Enter location' : null,
            //   onChanged: (value) {
            //     // call GEO-CODER to get coordinates and put a marker down on map
            //     // _goToAddress(value);
                
            //   }
            // ),

            const SizedBox(height: 12),

                // Google Map preview
                SizedBox(
                  height: 250,
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _mapPosition,
                      zoom: 12,
                    ),
                    markers: _marker != null ? {_marker!} : {},
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    zoomControlsEnabled: true,
                  ),
                ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              
              children: [
                // const Text(
                //   'Categories',
                //   style: TextStyle(fontWeight: FontWeight.bold),
                // ),

                // Display selected categories as removable chips
                

                const SizedBox(height: 8),

                // Button to select more categories
                ElevatedButton.icon(
                  onPressed: () async {
                    final chosen = await showDialog<List<String>>(
                      context: context,
                      builder: (context) {
                        // Local temp list to track selections in the dialog
                        List<String> tempSelected = List.from(selectedCategories);

                        return AlertDialog(
                          title: const Text('Select Categories'),
                          content: SizedBox(
                            width: double.maxFinite,
                            child: ListView(
                              shrinkWrap: true,
                              children: grabbedCategories.map((category) {
                                return CheckboxListTile(
                                  value: tempSelected.contains(category),
                                  title: Text(category),
                                  onChanged: (checked) {
                                    setState(() {
                                      if (checked == true &&
                                          tempSelected.length < 3) {
                                        tempSelected.add(category);
                                      } else {
                                        tempSelected.remove(category);
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, null),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () =>
                                  Navigator.pop(context, tempSelected),
                              child: const Text('Done'),
                            ),
                          ],
                        );
                      },
                    );

                    if (chosen != null) {
                      setState(() {
                        selectedCategories = chosen;
                      });
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Select Categories'),
                ),

                Wrap(
                  spacing: 8,
                  alignment: WrapAlignment.start, // <-- add this
                  children: selectedCategories.map((category) {
                    return Chip(
                      label: Text(category),
                      onDeleted: () {
                        setState(() {
                          selectedCategories.remove(category);
                        });
                      },
                    );
                  }).toList(),
                ),

                // Display error on form...
                // if (selectedCategories.isEmpty)
                //   const Padding(
                //     padding: EdgeInsets.only(top: 8),
                //     child: Text(
                //       'Please select at least one category',
                //       style: TextStyle(color: Colors.red),
                //     ),
                //   ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tags', style: TextStyle(fontWeight: FontWeight.bold)),

                // Display entered tags as chips
                Wrap(
                  spacing: 8,
                  children: selectedTags.map((tag) {
                    return Chip(
                      label: Text(tag),
                      onDeleted: () {
                        setState(() {
                          selectedTags.remove(tag);
                        });
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 8),

                // Input field for adding new tags
                Row(
                  children: [
                    Expanded(
                      child: 
                      BasicTextField(
                        label: 'Add Tags (#soccer / #KingKong)', 
                        controller: _tagsController
                      ),
                        
                      
                      // TextFormField(
                      //   controller: _tagsController,
                      //   decoration: const InputDecoration(labelText: 'Add a tag'),
                      //   onFieldSubmitted: (value) {
                      //     _addTag();
                      //   },
                      // ),
                    ),
                    IconButton(icon: const Icon(Icons.add), onPressed: _addTag),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitEvent,
              child: _isSubmitting
                  ? const CircularProgressIndicator()
                  : const Text('Submit Event'),
            ),
            const SizedBox(height: 20),
            if (_resultMessage.isNotEmpty)
              Text(
                _resultMessage,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    )
      )
    ) ;

    
  }
}
