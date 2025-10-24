import 'package:flutter/material.dart';
import 'package:vivo_front/api/Events/delete_event.dart';
import 'package:vivo_front/api/api_service.dart';
import 'package:vivo_front/stateless/delete_button.dart';
import 'package:vivo_front/stateless/generic_callback_button.dart';
import 'package:vivo_front/stateless/yes_no_dialog.dart';
import 'package:vivo_front/types/event.dart';


class EventFullView extends StatefulWidget {
  final GetEventPreview event; // receives widget.event from navigator call
  const EventFullView({super.key, required this.event});
  //  final Set<Marker>? markersSet;

  @override
  State<EventFullView> createState() => _EventFullViewState();
}

class _EventFullViewState extends State<EventFullView> {
  final ApiService api = ApiService(); 

  // late GetEventPreview widget.event;

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






  @override
  Widget build(BuildContext context) {
    // final dateFormatted = DateFormat('EEEE, MMM d • hh:mm a').format(
    //   DateTime.tryParse(widget.event.date) ?? DateTime.now(),
    // );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GenericCallBackButton(name: "Edit", onPressed: () {_goToEditEvent();}),
            // GenericCallBackButton(name: "Delete", onPressed: () async {
            //   // pop up first
            //   final confirmed = await showYesNoDialog(
            //     context,
            //     title: "Are you sure you want to delete this Event?",
            //   );

            //   if (confirmed == true) {
            //     _deleteEvent();
            //   }
                      
            //   }
            // ),
            // --- Title & Meta Info ---
            Text(
              widget.event.title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.event.createdAt,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.people_alt_rounded, size: 18),
                const SizedBox(width: 4),
                Text("${widget.event.interested} interested"),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(),

            // --- Description ---
            Text(
              "Description",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.event.description.isNotEmpty
                  ? widget.event.description
                  : "No description provided.",
              style: TextStyle(color: Colors.grey[800]),
            ),

            const SizedBox(height: 20),
            const Divider(),

            // --- Categories ---
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

            // --- Tags ---
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
            ],

            // --- Location ---
            const Divider(),
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

            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.map),
                label: const Text("View on Map"),
                onPressed: () {
                  // TODO: push to a map view page
                },
              ),
            ),
            const SizedBox(height: 30),
            DeleteButton(text: 'Delete Event', onPressed: () async {
              // pop up first
              final confirmed = await showYesNoDialog(
                context,
                title: "Are you sure you want to delete this Event?",
              );

              if (confirmed == true) {
                _deleteEvent();
              }
            })
          ],
        ),
      ),
    );
  }
}