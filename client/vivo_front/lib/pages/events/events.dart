
import 'package:flutter/material.dart';
import 'package:vivo_front/api/Events/get_events.dart';
import 'package:vivo_front/pages/events/CRUD/patch_event.dart';
import 'package:vivo_front/pages/events/CRUD/post_event.dart';
import 'package:vivo_front/api/api_service.dart';
import 'package:vivo_front/com_ui_widgets/mainpage_header.dart';
import 'package:vivo_front/pages/events/event_fullview.dart';
import 'package:vivo_front/types/event.dart';
import 'package:intl/intl.dart';


class EventsTab extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const EventsTab({super.key, required this.navigatorKey});

  

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: '/events',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;

        switch (settings.name) {
          case '/events':
            builder = (context) => EventsPage(); // Your main map UI
            break;
          case '/post_event':
            builder = (context) => PostEventForm(); // Subpage to push
            break;
          case '/edit_event':
            final event = settings.arguments as GetEventPreview; //pass data to this widget page on nav
            builder = (context) => PatchEventForm(event: event); // Subpage to push
            break;
          case '/view_event':
            final event = settings.arguments as GetEventPreview; //pass data to this widget page on nav
            builder = (context) => EventFullView(event: event); // Subpage to push
            break;
          default:
            builder = (context) => EventsPage();
        }

        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}




class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsState();
}

class _EventsState extends State<EventsPage> {

  final ApiService api = ApiService(); 

  List<GetEventPreview> eventsList = [];
  // bool _loading = true;
  // String? _error;

  int increTest = 0;


  @override
  void initState() {
    super.initState();
    _loadEvents();
      print("after get events after post frame");
  }

  // -------------------------------------------

  Future<void> _loadEvents() async {
    final events = await getEvents(api);
    setState(() {
      print("-------------set state for events list----------");
      eventsList = events;
      for (var e in eventsList) {
      print('Event: ${e.id}, ${e.title}, ${e.startTime} → ${e.endTime}, ${e.address}');
      }
    });
  }


  void _goToCreate() async {
    await Navigator.of(context).pushNamed('/post_event');
    // Reload events after returning
    // await _load();
  }

  

  // full view for an event...
  void _goToEventPage(GetEventPreview event) async {
    print('going to full view event page...');
    final updatedEvent = await Navigator.pushNamed(
      context,
      '/view_event',
      arguments: event,
    ) as GetEventPreview?;

    // // Execution resumes here after the page is popped
    // if (updatedEvent != null) {
    //   setState(() {
    //     // update your events list
    //     final index = eventsList.indexWhere((e) => e.id == updatedEvent.id);
    //     if (index != -1) eventsList[index] = updatedEvent;
    //   });
    // }
  }

 @override
  Widget build(BuildContext context) {
return Scaffold(
    
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToCreate,
      //   icon: const Icon(Icons.add),
      //   label: const Text('Create event'),
      // ),
      floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                 _goToCreate();
              },
              // shape: CircleBorder(
              //   side: BorderSide(color: Colors.grey.shade200, width: 4),
              // ),
              backgroundColor: Colors.grey.shade200,
              icon: const Icon(Icons.add,color: Colors.blue),
              label: const Text('Create Event', style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold)),
            ),
      body: Column(
        children: [
Expanded(
  child: ListView.builder(
    padding: const EdgeInsets.fromLTRB(16, 20, 16, 120),
    itemCount: eventsList.length,
    itemBuilder: (context, index) {
      final event = eventsList[index];

      return GestureDetector(
        onTap: () => _goToEventPage(event),
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.16),
                blurRadius: 10,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              /// Icon badge (left)
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  shape: BoxShape.rectangle, // Default value, often implied
                 borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                Icons.event,
                  color: Colors.blue,
                  size: 26,
                ),
              ),

              const SizedBox(width: 14),

              /// Title + subtitle (center)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('MMMM d, h:mm a').format(DateTime.parse(event.startTime)),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              /// Right-side stat
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    textAlign: TextAlign.center,
                    '${event.interested}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Interested',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  ),
),
    ] ),
    );
  }}