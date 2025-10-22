import 'package:flutter/material.dart';
import 'package:vivo_front/api/api_service.dart';
import 'package:vivo_front/types/event.dart';


class EventFullView extends StatefulWidget {
  const EventFullView({super.key});
  //  final Set<Marker>? markersSet;

  @override
  State<EventFullView> createState() => _EventFullViewState();
}

class _EventFullViewState extends State<EventFullView> {
  final ApiService api = ApiService(); 

  late GetEventPreview event;


  // fetch full event data right away ?
  // getEvent previews for markers
  Future<void> getEvents() async {
    try {
      print('calling get events preview');
      final event = await api.requestSingle<GetEventPreview>(
        endpoint: '/api/event-fullview', // or however your endpoint works
        parser: (item) => GetEventPreview.fromJson(item as Map<String, dynamic>),
      );


      // print("printer;categories returned: $categories");
      // developer.log("GET returned response: $categories", name:'vivo-loggy', level: 0);
      print("returned GET data: event");

      // IMPORTANT: setState() should be used to update UI / core to flutter/dart lifecycle...
      setState(() {
        this.event = event;
      });
    } catch (e) {
      print('error on getEvents in map.dart: $e');
    } finally {
      // setState(() {
      //   // _isSubmitting = false;
      //   print("done get events");
      // });
    }
  }






  @override
  Widget build(BuildContext context) {
    // final dateFormatted = DateFormat('EEEE, MMM d • hh:mm a').format(
    //   DateTime.tryParse(event.date) ?? DateTime.now(),
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
            // --- Title & Meta Info ---
            Text(
              event.title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              event.createdAt,
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
                Text("${event.interested} interested"),
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
              event.description.isNotEmpty
                  ? event.description
                  : "No description provided.",
              style: TextStyle(color: Colors.grey[800]),
            ),

            const SizedBox(height: 20),
            const Divider(),

            // --- Categories ---
            if (event.categories.isNotEmpty) ...[
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
                children: event.categories
                    .map((c) => Chip(
                          label: Text(c),
                          backgroundColor: Colors.blue.shade50,
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),
            ],

            // --- Tags ---
            if (event.tags.isNotEmpty) ...[
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
                children: event.tags
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
                    "Lat: ${event.latitude.toStringAsFixed(5)}, "
                    "Lng: ${event.longitude.toStringAsFixed(5)}",
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
          ],
        ),
      ),
    );
  }
}