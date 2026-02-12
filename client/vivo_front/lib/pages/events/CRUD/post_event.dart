import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:uuid/uuid.dart';
import 'package:vivo_front/api/api_service.dart';
import 'package:vivo_front/api/categories/get_categories.dart';
import 'package:vivo_front/api/google_map/google_map_wid.dart';
import 'package:vivo_front/api/google_map/map_helpers.dart';
import 'package:vivo_front/com_ui_widgets/padding.dart';
import 'package:vivo_front/com_ui_widgets/subpage_header.dart';
import 'package:vivo_front/utility/user_functions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vivo_front/api/google_map/google_places_search.dart';
import 'package:google_places_api_flutter/google_places_api_flutter.dart';
import 'package:minio/minio.dart';
import 'package:minio/io.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vivo_front/widgets/ImageUpload.dart';
import 'package:path/path.dart' as p;


class PostEventForm extends StatefulWidget {
  // accept callback for maps.dart - google maps instance
  const PostEventForm({super.key});

  @override
  State<PostEventForm> createState() => PostEventFormState();
}

class PostEventFormState extends State<PostEventForm> {
  final _formKey = GlobalKey<FormState>();
  final ApiService api = ApiService(); 

  // 📍 Initial location - should be grabbed from USER DEVICE
  final LatLng _initialPosition = const LatLng(44.389355, -79.690331);
  double curLat = 44.389355;
  double curLng = -79.690331;
  String curAddress = "18 Claudio Crescent";

  late Set<Marker> _markerSet = {};

  List<String> grabbedCategories = List.empty(); // fetched categories to choose from
  List<String> selectedCategories = []; // selected categories
  List<String> selectedTags = []; // tags

  // is loading / message
  bool _isSubmitting = false;
  String _resultMessage = '';

  ValueNotifier<bool> isEventWindow = ValueNotifier<bool>(false);

  // image uplioad url
  File? _uploadedImageUrl;
  String finalImageString = "";
  // re useable uuid instance
  final _uuid = Uuid(); 


  // Form controllers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagsController = TextEditingController();
  final _categoriesController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  final _locationController = TextEditingController();


  // ------------------------------------

  // runs on widget creation
  @override
  void initState() {
    super.initState();
    print('init in post eventer...........................');
    // developer.log("Post event form has ran hehe", name: 'vivo-loggy', level: 0);
    _loadData();
  }

  
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    _categoriesController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  // ----------------------------


  void showWindow() {
    isEventWindow.value = true;
  }







  Future<void> _loadData() async {
    final categories = await getCategories(api);
    setState(() {
      print("set state for events list...");
      grabbedCategories = categories;
    });
  }

  // Convert address to LatLng
  Future<void> _goToAddress(Prediction placeId, PlaceDetailsModel? placeDetails) async {
    try {

      print('inside goTo address after added...');

      if(placeDetails != null && placeDetails.result.geometry != null){
        final lat = placeDetails.result.geometry!.location.lat;
        final lng = placeDetails.result.geometry!.location.lng;
        final marker = MarkerBuilder.build(lat: lat, lng: lng);
        
        // form fields to set when new address is clicked on
        curLat = lat; // set lat 
        curLng = lng; // set lng
        curAddress = placeDetails.result.formatted_address!;
      
        // set State to show new marker for clicked on address.
        setState(() {
          _markerSet = {marker};
        });
      }
    } catch (e) {
      print('Error geocoding address: $e');
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


  Future<void> uploadFile(String filePath, Minio minio) async {
    print("attempting to upload file to S3 bucket...............................");
    String extension = p.extension(filePath); 
    final String? contentType = lookupMimeType(filePath);

    String uniqueId = _uuid.v4();

    // In production, use a UUID package for better uniqueness
    String fileName = 'images/$uniqueId$extension';
    print(fileName);

    // get byte stream and size
    final Stream<Uint8List> stream = _uploadedImageUrl!.openRead().map((chunk) => Uint8List.fromList(chunk));
    final size = await _uploadedImageUrl!.length();

    
    try{
      await minio.putObject(
        'vivo-image-storage', 
        fileName, // destination name of the image
        stream, // local path to the image itself
        size: size,
        metadata: {'Content-Type': contentType ?? 'application/octet-stream'},
      );
    }
    catch (e){
      return;
    }

      
    print("Upload complete!");

    // string to give to database for that image wherever it lives...
    //String finalUrl = 'https://vivo-image-storage.s3.amazonaws.com/$objectName';

    // store the actuual image link...
    finalImageString = 'https://vivo-image-storage.s3.us-east-1.amazonaws.com/$fileName';

  }



// ----------------------
// SUBMIT EVENT
  Future<void> _submitEvent() async {
    if (!_formKey.currentState!.validate()) return;


    print("image uploaded to widget: ");
    print(_uploadedImageUrl!.path);

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

    

    // upload image try catch block
    try {
      // create aws wrapper to upload
      final minio = Minio(
        endPoint: 's3.amazonaws.com', // or your region specific endpoint
        accessKey: dotenv.get('S3_ACCESS_KEY'),
        secretKey: dotenv.get('S3_SECRET_KEY'),
        region: 'us-east-1',
        useSSL: true
      );
      
      await uploadFile(_uploadedImageUrl!.path, minio);
      //s3://vivo-image-storage/gamescreenshot.png

      print("uploa dmaybe worked idk");
      
    } catch (e) {
      setState(() {
        _resultMessage = 'Submit event image upload error: $e';
      });
    } finally {
      print("s3 upload finally");
    }
    
    try {
      // get user id
      final userId = await getCurrentUserId();

    
      print({
          'userId': userId,
          'title': _titleController.text,
          'description': _descriptionController.text,
          'tags': selectedTags,
          'categories': selectedCategories,
          'startTime': _startTimeController.text,
          'endTime': _endTimeController.text,
          'address': curAddress, //needs to take physical address (77 dancer rd, toronto, On, Canada)
          'lat': curLat,
          'lng': curLng,
          'eventImage': finalImageString
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
          'startTime': _startTimeController.text,
          'endTime': _endTimeController.text,
          'address': curAddress, //needs to take physical address (77 dancer rd, toronto, On, Canada)
          'lat': curLat,
          'lng': curLng,
          'eventImage': finalImageString
        },
      );

      print(newEvent);
      print("post event after req...");

      setState(() {
        _resultMessage = '✅ Event created';
      });

      // print(newEvent);

      // Clear form
      selectedCategories.clear();
      selectedTags.clear();
      _titleController.clear();
      _descriptionController.clear();
      _tagsController.clear();
      _categoriesController.clear();
      _startTimeController.clear();
      _endTimeController.clear();
      _locationController.clear();
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

            // Insert image here...
            // 2. Insert the class with the callback
              ImageUpload(
                onUploadComplete: (url) {
                  setState(() {

                    _uploadedImageUrl = url; // Update parent state
                  });
                },
              ),


            // display current image that has been uploaded...
            ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: Container(
                color: Colors.grey.shade300,
              child: const Icon(Icons.add_a_photo_outlined, size: 100, color: Colors.black,),
            ),
          ),
          ),
          const SizedBox(height: 20),

            // Title 
            BasicTextField( controller: _titleController,
              label: 'Title',
              validator: (v) => v == null || v.isEmpty ? 'Enter title' : null
            ),
            
            // Description
            BasicTextField( controller: _descriptionController,
              label: 'Description',
              maxLines: 5,
              maxLength: 250,
              keyboardType: TextInputType.multiline,
              validator: (v) => v == null || v.isEmpty ? 'Description' : null
            ),

            // Start Time field
            BasicTextField(
              controller: _startTimeController,
              label: 'Start Time',
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
                  _startTimeController.text =
                      "${finalDateTime.year.toString().padLeft(4, '0')}-"
                      "${finalDateTime.month.toString().padLeft(2, '0')}-"
                      "${finalDateTime.day.toString().padLeft(2, '0')} "
                      "${finalDateTime.hour.toString().padLeft(2, '0')}:"
                      "${finalDateTime.minute.toString().padLeft(2, '0')}";
                });
              },
            ),

            // End Time 
            BasicTextField(
              controller: _endTimeController,
              label: 'End Time',
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
                  _endTimeController.text =
                      "${finalDateTime.year.toString().padLeft(4, '0')}-"
                      "${finalDateTime.month.toString().padLeft(2, '0')}-"
                      "${finalDateTime.day.toString().padLeft(2, '0')} "
                      "${finalDateTime.hour.toString().padLeft(2, '0')}:"
                      "${finalDateTime.minute.toString().padLeft(2, '0')}";
                });
              },
            ),

            // Google Places search bar
            PlacesSearch(onPlaceSelectedCallback: _goToAddress),

            // mini google map to show the location picked...
            MapSample(
              mapPosition: _initialPosition,  
              zoom: 11.0,
              height: 250,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
              markersSet: _markerSet,
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
