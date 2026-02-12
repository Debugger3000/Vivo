import 'package:flutter/material.dart';
import 'package:vivo_front/api/Events/delete_event.dart';
import 'package:vivo_front/api/api_service.dart';
import 'package:vivo_front/stateless/delete_button.dart';
import 'package:vivo_front/stateless/generic_callback_button.dart';
import 'package:vivo_front/stateless/imageview.dart';
import 'package:vivo_front/stateless/yes_no_dialog.dart';
import 'package:vivo_front/types/event.dart';
import 'package:intl/intl.dart';
import 'package:vivo_front/utility/user_functions.dart';


class EventFullView extends StatefulWidget {
  final GetEventPreview event; // receives widget.event from navigator call
  const EventFullView({super.key, required this.event});
  //  final Set<Marker>? markersSet;

  @override
  State<EventFullView> createState() => _EventFullViewState();
}

class _EventFullViewState extends State<EventFullView> {
  final ApiService api = ApiService(); 
  String? userId;

  // late GetEventPreview widget.event;



  @override
  void initState() {
    super.initState();
    // 1. Initialize your data or controllers here
    print("Page is initializing...");
    wrapGetId(); // get user id on call....
  }

  Future<void> wrapGetId() async{
    String? id = await getCurrentUserId();
    setState(() {
      userId = id;
  });
  }

  void _goToEditEvent() async {
    print('going to edit event page...');
    final updatedEvent = await Navigator.pushNamed(
      context,
      '/edit_event',
      arguments: widget.event,
    ) as GetEventPreview?;

    // Execution resumes here after the page is popped
    // if (updatedEvent != null) {
    //   setState(() {
    //     // update your events list
    //     final index = eventsList.indexWhere((e) => e.id == updatedEvent.id);
    //     if (index != -1) eventsList[index] = updatedEvent;
    //   });
    // }
  }

  void _deleteEvent() async {
    final result = await deleteEvent(api, widget.event.id);
    if(result){
      Navigator.of(context).pop();
    }
    else{
      print('event deletion failed...');
    }
    
    // Reload events after returning
    // await _load();
  }








  // @override
  // Widget build(BuildContext context) {
  //   // final dateFormatted = DateFormat('EEEE, MMM d • hh:mm a').format(
  //   //   DateTime.tryParse(widget.event.date) ?? DateTime.now(),
  //   // );
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Event Details'),
  //       centerTitle: false,
  //     ),
  //     body: SingleChildScrollView(
  //       padding: const EdgeInsets.all(16),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           GenericCallBackButton(name: "Edit", onPressed: () {_goToEditEvent();}),
  //           // --- Title & Meta Info ---
  //           Text(
  //             widget.event.title,
  //             style: Theme.of(context).textTheme.headlineMedium?.copyWith(
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //           ),
  //           const SizedBox(height: 4),
  //           Text(
  //             widget.event.createdAt,
  //             style: TextStyle(
  //               color: Colors.grey[600],
  //               fontSize: 14,
  //             ),
  //           ),
  //           const SizedBox(height: 8),
  //           Row(
  //             children: [
  //               const Icon(Icons.people_alt_rounded, size: 18),
  //               const SizedBox(width: 4),
  //               Text("${widget.event.interested} interested"),
  //             ],
  //           ),

  //           const SizedBox(height: 16),
  //           const Divider(),

  //           // --- Description ---
  //           Text(
  //             "Description",
  //             style: Theme.of(context).textTheme.titleMedium?.copyWith(
  //                   fontWeight: FontWeight.w600,
  //                 ),
  //           ),
  //           const SizedBox(height: 6),
  //           Text(
  //             widget.event.description.isNotEmpty
  //                 ? widget.event.description
  //                 : "No description provided.",
  //             style: TextStyle(color: Colors.grey[800]),
  //           ),

  //           const SizedBox(height: 20),
  //           const Divider(),

  //           // --- Categories ---
  //           if (widget.event.categories.isNotEmpty) ...[
  //             Text(
  //               "Categories",
  //               style: Theme.of(context).textTheme.titleMedium?.copyWith(
  //                     fontWeight: FontWeight.w600,
  //                   ),
  //             ),
  //             const SizedBox(height: 6),
  //             Wrap(
  //               spacing: 8,
  //               runSpacing: 6,
  //               children: widget.event.categories
  //                   .map((c) => Chip(
  //                         label: Text(c),
  //                         backgroundColor: Colors.blue.shade50,
  //                       ))
  //                   .toList(),
  //             ),
  //             const SizedBox(height: 20),
  //           ],

  //           // --- Tags ---
  //           if (widget.event.tags.isNotEmpty) ...[
  //             Text(
  //               "Tags",
  //               style: Theme.of(context).textTheme.titleMedium?.copyWith(
  //                     fontWeight: FontWeight.w600,
  //                   ),
  //             ),
  //             const SizedBox(height: 6),
  //             Wrap(
  //               spacing: 8,
  //               runSpacing: 6,
  //               children: widget.event.tags
  //                   .map((t) => Chip(
  //                         label: Text("#$t"),
  //                         backgroundColor: Colors.green.shade50,
  //                       ))
  //                   .toList(),
  //             ),
  //             const SizedBox(height: 20),
  //           ],

  //           // --- Location ---
  //           const Divider(),
  //           Text(
  //             "Location",
  //             style: Theme.of(context).textTheme.titleMedium?.copyWith(
  //                   fontWeight: FontWeight.w600,
  //                 ),
  //           ),
  //           const SizedBox(height: 6),
  //           Row(
  //             children: [
  //               const Icon(Icons.location_on_outlined, color: Colors.redAccent),
  //               const SizedBox(width: 6),
  //               Expanded(
  //                 child: Text(
  //                   widget.event.address,
  //                   style: TextStyle(color: Colors.grey[700]),
  //                 ),
  //               ),
  //             ],
  //           ),

  //           const SizedBox(height: 30),
  //           Center(
  //             child: ElevatedButton.icon(
  //               icon: const Icon(Icons.map),
  //               label: const Text("View on Map"),
  //               onPressed: () {
  //                 // TODO: push to a map view page
  //               },
  //             ),
  //           ),
  //           const SizedBox(height: 30),
  //           DeleteButton(text: 'Delete Event', onPressed: () async {
  //             // pop up first
  //             final confirmed = await showYesNoDialog(
  //               context,
  //               title: "Are you sure you want to delete this Event?",
  //             );

  //             if (confirmed == true) {
  //               _deleteEvent();
  //             }
  //           })
  //         ],
  //       ),
  //     ),
  //   );
  // }


//---------------------------------------------------------------------------------------------------//



 @override
 Widget build(BuildContext context) {
    final formattedStartTime = DateFormat(
      'MMMM d, h:mm a',
    ).format(
      DateTime.parse(widget.event.startTime),
    );

   return Scaffold(
     backgroundColor: Colors.white,
     appBar: AppBar(
       elevation: 0,
       backgroundColor: Colors.white,
       leading: IconButton(
        icon: const Icon(Icons.close, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        widget.event.title,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      
    ),

    bottomNavigationBar: Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 25),
      // child: SizedBox(
      //   height: 56,
      //   child: ElevatedButton(
      //     style: ElevatedButton.styleFrom(
      //       backgroundColor: const Color(0xFF7FE6F2),
      //       shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.circular(30),
      //       ),
      //       elevation: 6,
      //     ),
      //     onPressed: () {
      //       // TODO: Interested logic
      //     },
      //     child: const Text(
      //       "Im Interested",
      //       style: TextStyle(
      //         fontSize: 18,
      //         fontWeight: FontWeight.w600,
      //         color: Colors.black,
      //       ),
      //     ),
      //   ),
      // ),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImageView(imageUrl: widget.event.eventImage),

//           // EVENT IMAGE
          // ClipRRect(
          //   borderRadius: BorderRadius.circular(20),
          //   child: AspectRatio(
          //     aspectRatio: 4 / 3,
          //     child: Container(
          //       color: Colors.grey.shade300,
          //     child: const Icon(Icons.add_a_photo_outlined, size: 100, color: Colors.black,),
          //   ),
          // ),
          // ),
          const SizedBox(height: 20),

       /// LOCATION
       Text(
              "Location",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
             const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, color: Colors.redAccent),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    widget.event.address,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
              ],
            ),

        const SizedBox(height: 10),

        /// TIME 
           Text(
              "Time",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
             const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.access_time_outlined, color: Colors.redAccent),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    formattedStartTime,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
              ],
            ),

        const SizedBox(height: 10),
         /// DESCRIPTION TITLE
          const Text(
            "Description",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          /// DESCRIPTION TEXT
          Text(
            widget.event.description,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[800],
              height: 1.4,
            ),
          ),

          const SizedBox(height: 14),

//           /// CATEGORY
if (widget.event.categories.isNotEmpty) ...[
              Text(
                "Categories",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: widget.event.categories
                    .map((c) => Chip(
                          label: Text(c),
                          backgroundColor: Colors.blue.shade50,
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),
            ],

      /// HASHTAGS
   if (widget.event.tags.isNotEmpty) ...[
              Text(
                "Tags",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: widget.event.tags
                    .map((t) => Chip(
                          label: Text("#$t"),
                          backgroundColor: Colors.green.shade50,
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),
               Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.map),
                label: const Text("View on Map"),
                onPressed: () {
                  // TODO: push to a map view page
                },
              ),
            ),
            ],

          const SizedBox(height: 50), // space for button
          Center(
              child: ElevatedButton.icon(
                label: const Text(
                  "Im Interested",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7FE6F2),
                  minimumSize: const Size(17500, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  
                  elevation: 6,
                ),
                onPressed: () {
                  // TODO: Im Interested logic
                },
              ),
            ),
            //const SizedBox(height: 8),
            if(userId == widget.event.userId)
              const SizedBox(height: 50),
              DeleteButton(text: 'Delete Event', onPressed: () async {
                // pop up first
                final confirmed = await showYesNoDialog(
                  context,
                  title: "Are you sure you want to delete this Event?",
                );

                if (confirmed == true) {
                  _deleteEvent();
                }
              }),
            
             
              const SizedBox(height: 50),
              GenericCallBackButton(name: "Edit", onPressed: () {_goToEditEvent();})
            ],
            
      ),
      
    ),
  );
}

} 

 